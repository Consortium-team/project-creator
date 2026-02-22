#!/usr/bin/env bash
set -euo pipefail

# Hook: project-context
# Runs on UserPromptSubmit. Handles /project command filesystem operations
# so the LLM receives pre-computed results via additionalContext.
#
# Fast path: non-/project prompts exit in ~6ms.
# All errors exit 0 with structured data — never exit 2 (blocks prompt).

# --- Read stdin, extract prompt ---

INPUT=$(cat)

if ! command -v jq &>/dev/null; then
  echo "Warning: jq not found, project-context hook disabled" >&2
  exit 0
fi

PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')
if [ -z "$PROMPT" ]; then
  exit 0
fi

# --- Fast path: skip non-/project prompts ---

FIRST_LINE=$(echo "$PROMPT" | head -1)
if ! echo "$FIRST_LINE" | grep -qE '^# /project( |$)'; then
  exit 0
fi

# --- This is a /project command ---

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
PROJECTS_DIR="$PROJECT_DIR/projects"
TRACKING_DIR="$PROJECT_DIR/tracking"
CURRENT_FILE="$TRACKING_DIR/current-project.md"

# Extract arguments from the ## Argument: line
ARGS=$(echo "$PROMPT" | grep -m1 '^## Argument:' | sed 's/^## Argument: *//' | sed 's/[[:space:]]*$//' || true)

# --- Helpers ---

read_current() {
  if [ -f "$CURRENT_FILE" ]; then
    local val
    val=$(tr -d '[:space:]' < "$CURRENT_FILE")
    if [ -n "$val" ] && validate_path "$val"; then
      echo "$val"
      return
    fi
  fi
  echo "none"
}

list_projects() {
  local current="$1"
  if [ ! -d "$PROJECTS_DIR" ]; then
    echo "  (none)"
    return
  fi
  local found=0
  for client_dir in "$PROJECTS_DIR"/*/; do
    [ -d "$client_dir" ] || continue
    local client
    client=$(basename "$client_dir")
    for proj_dir in "$client_dir"/*/; do
      [ -d "$proj_dir" ] || continue
      local proj
      proj=$(basename "$proj_dir")
      local path="$client/$proj"
      found=1
      if [ "$path" = "$current" ]; then
        echo "  - $path (current)"
      else
        echo "  - $path"
      fi
    done
  done
  if [ "$found" -eq 0 ]; then
    echo "  (none)"
  fi
}

validate_path() {
  echo "$1" | grep -qE '^[a-z0-9]([a-z0-9-]*[a-z0-9])?/[a-z0-9]([a-z0-9-]*[a-z0-9])?$'
}

output() {
  printf '{"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": %s}}' "$(echo "$1" | jq -Rs .)"
}

# --- Mode dispatch ---

if [ -z "$ARGS" ]; then
  # ========== Mode 1: Show ==========
  CURRENT=$(read_current)
  PROJECTS=$(list_projects "$CURRENT")

  RESULT="[project-context-hook]
mode: show
status: success
current_project: $CURRENT
projects:
$PROJECTS
[/project-context-hook]"

  output "$RESULT"

elif [ "$ARGS" = "new" ] || echo "$ARGS" | grep -q '^new '; then
  # ========== Mode 3: New ==========
  PATH_ARG=$(echo "$ARGS" | sed 's/^new *//' | sed 's/[[:space:]]*$//')

  if [ -z "$PATH_ARG" ]; then
    RESULT="[project-context-hook]
mode: new
status: error
error_type: missing_path
message: Usage: /project new client/project
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  if ! validate_path "$PATH_ARG"; then
    RESULT="[project-context-hook]
mode: new
status: error
error_type: invalid_path
requested_path: $PATH_ARG
message: Path must be client/project format (lowercase alphanumeric + hyphens)
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  CLIENT=$(echo "$PATH_ARG" | cut -d/ -f1)
  PROJECT_NAME=$(echo "$PATH_ARG" | cut -d/ -f2)
  PROJECT_PATH="$PROJECTS_DIR/$CLIENT/$PROJECT_NAME"

  if [ -d "$PROJECT_PATH" ]; then
    RESULT="[project-context-hook]
mode: new
status: error
error_type: already_exists
requested_path: $PATH_ARG
message: Project already exists. Use /project $PATH_ARG to set it as current.
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  # Create directories (guarded — set -e must not cause unstructured exit)
  if ! mkdir -p "$TRACKING_DIR" 2>/dev/null || ! mkdir -p "$PROJECT_PATH/context" 2>/dev/null; then
    RESULT="[project-context-hook]
mode: new
status: error
error_type: filesystem_error
message: Failed to create project directories
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  # Init git
  GIT_WARNING=""
  GIT_OK=true
  if ! git init --quiet "$PROJECT_PATH" 2>/dev/null; then
    GIT_WARNING="
warning: git init failed"
    GIT_OK=false
  fi

  # Update current project
  TRACKING_OK=true
  if ! echo "$PATH_ARG" > "$CURRENT_FILE" 2>/dev/null; then
    GIT_WARNING="${GIT_WARNING}
warning: failed to update current-project.md"
    TRACKING_OK=false
  fi

  TODAY=$(date +%Y-%m-%d)

  ACTIONS="  - Created projects/$CLIENT/$PROJECT_NAME/
  - Created projects/$CLIENT/$PROJECT_NAME/context/"
  if [ "$GIT_OK" = true ]; then
    ACTIONS="$ACTIONS
  - Initialized git repository"
  fi
  if [ "$TRACKING_OK" = true ]; then
    ACTIONS="$ACTIONS
  - Updated tracking/current-project.md"
  fi

  RESULT="[project-context-hook]
mode: new
status: success
project_path: $PATH_ARG
created_date: $TODAY
actions_taken:
$ACTIONS
remaining_action: Update tracking/projects-log.md
new_row: | $CLIENT | $PROJECT_NAME | Seeding | $TODAY |$GIT_WARNING
[/project-context-hook]"

  output "$RESULT"

else
  # ========== Mode 2: Set ==========
  PATH_ARG=$(echo "$ARGS" | tr -d '[:space:]')
  PATH_ARG="${PATH_ARG%/}"

  if ! validate_path "$PATH_ARG"; then
    RESULT="[project-context-hook]
mode: set
status: error
error_type: invalid_path
requested_path: $PATH_ARG
message: Path must be client/project format (lowercase alphanumeric + hyphens)
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  CLIENT=$(echo "$PATH_ARG" | cut -d/ -f1)
  PROJECT_NAME=$(echo "$PATH_ARG" | cut -d/ -f2)
  PROJECT_PATH="$PROJECTS_DIR/$CLIENT/$PROJECT_NAME"

  if [ ! -d "$PROJECT_PATH" ]; then
    CURRENT=$(read_current)
    PROJECTS=$(list_projects "$CURRENT")
    RESULT="[project-context-hook]
mode: set
status: error
error_type: project_not_found
requested_path: $PATH_ARG
available_projects:
$PROJECTS
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  # Read previous before updating
  PREVIOUS=$(read_current)

  # Update current project (guarded — set -e must not cause unstructured exit)
  if ! mkdir -p "$TRACKING_DIR" 2>/dev/null; then
    RESULT="[project-context-hook]
mode: set
status: error
error_type: filesystem_error
message: Failed to create tracking directory
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi
  if ! echo "$PATH_ARG" > "$CURRENT_FILE" 2>/dev/null; then
    RESULT="[project-context-hook]
mode: set
status: error
error_type: filesystem_error
message: Failed to update current-project.md
[/project-context-hook]"
    output "$RESULT"
    exit 0
  fi

  RESULT="[project-context-hook]
mode: set
status: success
project_path: $PATH_ARG
previous_project: $PREVIOUS
[/project-context-hook]"

  output "$RESULT"
fi
