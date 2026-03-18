#!/usr/bin/env bash
set -euo pipefail

# Hook: companion-context
# Runs on UserPromptSubmit. Handles /companion command filesystem operations
# so the LLM receives pre-computed results via additionalContext.
#
# Fast path: non-/companion prompts exit in ~6ms.
# All errors exit 0 with structured data — never exit 2 (blocks prompt).

# --- Read stdin, extract prompt ---

INPUT=$(cat)

if ! command -v jq &>/dev/null; then
  echo "Warning: jq not found, companion-context hook disabled" >&2
  exit 0
fi

PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')
if [ -z "$PROMPT" ]; then
  exit 0
fi

# --- Fast path: skip non-/companion prompts ---
# Use grep on full prompt (not just first line) to handle potential YAML frontmatter

if ! echo "$PROMPT" | grep -qm1 '^# /companion'; then
  exit 0
fi

# --- This is a /companion command ---

BASE_DIR="${CLAUDE_PROJECT_DIR:-.}"
COMPANIONS_DIR="$BASE_DIR/companions"
COMPANION_KITS_DIR="$BASE_DIR/companion-kits/private-kits"
TRACKING_DIR="$BASE_DIR/tracking"
CURRENT_FILE="$TRACKING_DIR/current-companion.md"

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

list_companions() {
  local current="$1"
  if [ ! -d "$COMPANIONS_DIR" ]; then
    echo "  (none)"
    return
  fi
  local found=0
  for client_dir in "$COMPANIONS_DIR"/*/; do
    [ -d "$client_dir" ] || continue
    local client
    client=$(basename "$client_dir")
    for comp_dir in "$client_dir"/*/; do
      [ -d "$comp_dir" ] || continue
      local comp
      comp=$(basename "$comp_dir")
      local path="$client/$comp"
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
  COMPANIONS=$(list_companions "$CURRENT")

  RESULT="[companion-context-hook]
mode: show
status: success
current_companion: $CURRENT
companions:
$COMPANIONS
[/companion-context-hook]"

  output "$RESULT"

elif [ "$ARGS" = "new" ] || echo "$ARGS" | grep -q '^new '; then
  # ========== Mode 3: New ==========
  PATH_ARG=$(echo "$ARGS" | sed 's/^new *//' | sed 's/[[:space:]]*$//')

  if [ -z "$PATH_ARG" ]; then
    RESULT="[companion-context-hook]
mode: new
status: error
error_type: missing_path
message: Usage: /companion new client/companion
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  if ! validate_path "$PATH_ARG"; then
    RESULT="[companion-context-hook]
mode: new
status: error
error_type: invalid_path
requested_path: $PATH_ARG
message: Path must be client/companion format (lowercase alphanumeric + hyphens)
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  CLIENT=$(echo "$PATH_ARG" | cut -d/ -f1)
  COMPANION_NAME=$(echo "$PATH_ARG" | cut -d/ -f2)
  COMPANION_PATH="$COMPANIONS_DIR/$CLIENT/$COMPANION_NAME"

  if [ -d "$COMPANION_PATH" ]; then
    RESULT="[companion-context-hook]
mode: new
status: error
error_type: already_exists
requested_path: $PATH_ARG
message: Companion already exists. Use /companion $PATH_ARG to set it as current.
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  # Create companion directories (guarded — set -e must not cause unstructured exit)
  if ! mkdir -p "$TRACKING_DIR" 2>/dev/null || ! mkdir -p "$COMPANION_PATH/context" 2>/dev/null; then
    RESULT="[companion-context-hook]
mode: new
status: error
error_type: filesystem_error
message: Failed to create companion directories
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  # Init git
  GIT_WARNING=""
  GIT_OK=true
  if ! git init --quiet "$COMPANION_PATH" 2>/dev/null; then
    GIT_WARNING="
warning: git init failed"
    GIT_OK=false
  fi

  # Update current companion
  TRACKING_OK=true
  if ! echo "$PATH_ARG" > "$CURRENT_FILE" 2>/dev/null; then
    GIT_WARNING="${GIT_WARNING}
warning: failed to update current-companion.md"
    TRACKING_OK=false
  fi

  # Create companion-kit directories (idempotent, non-fatal)
  KIT_DIR="$COMPANION_KITS_DIR/${CLIENT}-companion-kit"
  KIT_CREATED="false"
  if [ -d "$KIT_DIR" ]; then
    KIT_CREATED="existing"
  else
    if mkdir -p "$KIT_DIR/personas" 2>/dev/null \
      && mkdir -p "$KIT_DIR/capabilities" 2>/dev/null \
      && mkdir -p "$KIT_DIR/library" 2>/dev/null; then
      KIT_CREATED="true"
    else
      GIT_WARNING="${GIT_WARNING}
warning: companion-kit creation failed (non-fatal)"
    fi
  fi

  TODAY=$(date +%Y-%m-%d)

  ACTIONS="  - Created companions/$CLIENT/$COMPANION_NAME/
  - Created companions/$CLIENT/$COMPANION_NAME/context/"
  if [ "$GIT_OK" = true ]; then
    ACTIONS="$ACTIONS
  - Initialized git repository"
  fi
  if [ "$TRACKING_OK" = true ]; then
    ACTIONS="$ACTIONS
  - Updated tracking/current-companion.md"
  fi
  if [ "$KIT_CREATED" = "true" ]; then
    ACTIONS="$ACTIONS
  - Created companion-kits/private-kits/${CLIENT}-companion-kit/ (personas/, capabilities/, library/)"
  elif [ "$KIT_CREATED" = "existing" ]; then
    ACTIONS="$ACTIONS
  - Companion kit already exists: companion-kits/private-kits/${CLIENT}-companion-kit/"
  fi

  RESULT="[companion-context-hook]
mode: new
status: success
companion_path: $PATH_ARG
companion_kit: ${CLIENT}-companion-kit
kit_created: $KIT_CREATED
created_date: $TODAY
actions_taken:
$ACTIONS
remaining_action: Update tracking/projects-log.md
new_row: | $CLIENT | $COMPANION_NAME | Seeding | $TODAY | | |$GIT_WARNING
[/companion-context-hook]"

  output "$RESULT"

else
  # ========== Mode 2: Set ==========
  PATH_ARG=$(echo "$ARGS" | tr -d '[:space:]')
  PATH_ARG="${PATH_ARG%/}"

  if ! validate_path "$PATH_ARG"; then
    RESULT="[companion-context-hook]
mode: set
status: error
error_type: invalid_path
requested_path: $PATH_ARG
message: Path must be client/companion format (lowercase alphanumeric + hyphens)
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  CLIENT=$(echo "$PATH_ARG" | cut -d/ -f1)
  COMPANION_NAME=$(echo "$PATH_ARG" | cut -d/ -f2)
  COMPANION_PATH="$COMPANIONS_DIR/$CLIENT/$COMPANION_NAME"

  if [ ! -d "$COMPANION_PATH" ]; then
    CURRENT=$(read_current)
    COMPANIONS=$(list_companions "$CURRENT")
    RESULT="[companion-context-hook]
mode: set
status: error
error_type: companion_not_found
requested_path: $PATH_ARG
available_companions:
$COMPANIONS
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  # Read previous before updating
  PREVIOUS=$(read_current)

  # Update current companion (guarded — set -e must not cause unstructured exit)
  if ! mkdir -p "$TRACKING_DIR" 2>/dev/null; then
    RESULT="[companion-context-hook]
mode: set
status: error
error_type: filesystem_error
message: Failed to create tracking directory
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi
  if ! echo "$PATH_ARG" > "$CURRENT_FILE" 2>/dev/null; then
    RESULT="[companion-context-hook]
mode: set
status: error
error_type: filesystem_error
message: Failed to update current-companion.md
[/companion-context-hook]"
    output "$RESULT"
    exit 0
  fi

  RESULT="[companion-context-hook]
mode: set
status: success
companion_path: $PATH_ARG
previous_companion: $PREVIOUS
[/companion-context-hook]"

  output "$RESULT"
fi