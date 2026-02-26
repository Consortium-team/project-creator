# /configure — Set Up Project Creator

First-run setup and ongoing configuration for your Project Creator instance.

## Usage

```
/configure                    # Run setup or update configuration
```

## Argument: $ARGUMENTS

---

## Instructions

### Step 1: Check Current State

Read existing configuration to determine if this is a first run or a reconfiguration:

1. Check if `tracking/permissions.yaml` exists
2. Check if `companions/` directory exists
3. Check if `companion-kits/private-kits/` has any kit directories
4. Check if a legacy `projects/` directory exists

**If `tracking/permissions.yaml` exists:**
- This is a reconfiguration. Read the file and show current settings:
  ```
  Current configuration:

  Organization: [org name]
  Always-accessible kits: [list]
  Companion directory: companions/

  What would you like to update?
  1. Add a new always-accessible kit to permissions
  2. Remove a kit from permissions
  3. View full configuration
  ```
- Wait for user input and handle accordingly.

**If `tracking/permissions.yaml` does NOT exist:**
- This is a first run. Proceed to Step 2.

---

### Step 2: Ask Who You Are

```
Welcome to Project Creator!

Let's get you set up. First question:

What's your organization name? (This will be used to create your companion kit and companions directory.)

Examples: consortium.team, acme-corp, my-company
```

Wait for user response. Store as `org_name`.

---

### Step 3: Create Directory Structure

Create all necessary directories:

```bash
# Companion kit for this org
mkdir -p companion-kits/private-kits/[org_name]-companion-kit/personas
mkdir -p companion-kits/private-kits/[org_name]-companion-kit/capabilities
mkdir -p companion-kits/private-kits/[org_name]-companion-kit/library

# Companions directory for this org
mkdir -p companions/[org_name]

# Tracking directory (if it doesn't exist)
mkdir -p tracking
```

---

### Step 4: Create Permissions File

Create `tracking/permissions.yaml`:

```yaml
# Project Creator Permissions
# Controls which private companion kits are accessible during intake and other commands.
#
# How kit access works:
# - Public kits (companion-kits/public-kits/) are ALWAYS accessible
# - The current companion's client kit is ALWAYS accessible (derived from companion path)
# - Kits listed below are ALSO always accessible, regardless of which companion is active
#
# Example: If you're consortium.team and always want your own kit available
# even when working on a client's companion:
#
#   always_accessible_private_kits:
#     - consortium.team-companion-kit

organization: "[org_name]"

always_accessible_private_kits:
  - [org_name]-companion-kit
```

---

### Step 5: Create Current Companion Tracking File

If `tracking/current-companion.md` doesn't exist, create it:

```markdown
No companion currently set
```

---

### Step 6: Create Projects Log

If `tracking/projects-log.md` doesn't exist, create it with the standard template:

```markdown
# Projects Log

Registry of all companions created or onboarded through Project Creator.

---

## Active Projects

| Client | Companion | Status | Created | Last Session | Notes |
|--------|-----------|--------|---------|--------------|-------|

---

## Status Key

| Status | Meaning |
|--------|---------|
| **seeding** | Capturing requirements, processing inputs |
| **cultivation** | Developing requirements, resolving ambiguity |
| **shaping** | Generating artifacts, validating |
| **graduated** | Moved to independent Claude Code project |
| **paused** | Work stopped, may resume |
| **archived** | No longer active |

---

## Session Log

Recent sessions are logged here by `/checkpoint`.
```

---

### Step 7: Check for Legacy Migration

Check if a `projects/` directory exists with content:

```bash
ls projects/
```

**If `projects/` exists and has client directories:**

```
I found a legacy projects/ directory with these clients:

  [client-a]/
    [project-1]
    [project-2]
  [client-b]/
    [project-3]

Would you like to migrate these to the new companions/ directory?

This will:
- Move each client directory from projects/ to companions/
- Create companion-kit directories for any new clients
- The projects/ directory will be left empty

Proceed? (yes/no)
```

**If user says yes:**

For each client directory in `projects/`:

1. Move the client directory:
   ```bash
   mv projects/[client]/* companions/[client]/
   ```
   (Create `companions/[client]/` first if it doesn't exist)

2. Create companion-kit for the client if it doesn't exist:
   ```bash
   mkdir -p companion-kits/private-kits/[client]-companion-kit/personas
   mkdir -p companion-kits/private-kits/[client]-companion-kit/capabilities
   mkdir -p companion-kits/private-kits/[client]-companion-kit/library
   ```

3. Report each migration:
   ```
   Migrated: [client]/[project-1] → companions/[client]/[project-1]
   Migrated: [client]/[project-2] → companions/[client]/[project-2]
   Created kit: companion-kits/private-kits/[client]-companion-kit/
   ```

**If user says no:** Skip migration. The projects/ directory remains untouched.

**If `projects/` doesn't exist or is empty:** Skip this step.

---

### Step 8: Verify .gitignore

Check that `.gitignore` includes the necessary entries:

- `companions/` — companion projects (git-ignored)
- `companion-kits/private-kits/` — private kits (git-ignored)
- `tracking/` — tracking files (git-ignored)

If any are missing, report them but do NOT modify `.gitignore` automatically — it's a tracked file.

```
Note: Make sure your .gitignore includes:
  companions/
  companion-kits/private-kits/
  tracking/
```

---

### Step 9: Confirm Setup

```
## Configuration Complete

**Organization:** [org_name]

**Directories created:**
- companion-kits/private-kits/[org_name]-companion-kit/ (personas, capabilities, library)
- companions/[org_name]/

**Permissions:**
- Public kits: always accessible
- [org_name]-companion-kit: always accessible
- Client kits: accessible when working on that client's companion

**Tracking:**
- tracking/permissions.yaml
- tracking/current-companion.md
- tracking/projects-log.md

[If migration happened:]
**Migrated from projects/:**
- [count] companions across [count] clients

---

**Next steps:**
  /companion new [org_name]/my-first-companion   — Create your first companion
  /intake                                         — Start capturing requirements
```

---

## Reconfiguration Options

When `/configure` is run on an already-configured instance:

### Add a kit to permissions

```
Which private kit should be always-accessible?

Available kits:
- [list from companion-kits/private-kits/]

Currently always-accessible:
- [list from permissions.yaml]
```

Add the selected kit to `always_accessible_private_kits` in `tracking/permissions.yaml`.

### Remove a kit from permissions

Show the current list and let user remove one. Update `tracking/permissions.yaml`.

---

## Design Rationale

- **First run creates everything** — New users shouldn't have to manually create gitignored directories
- **Migration is opt-in** — Users may want to keep projects/ intact while they test the new structure
- **Permissions default to own org** — The most common case is wanting your own kit always available
- **Reconfigurable** — Permissions can be updated anytime without re-running full setup
