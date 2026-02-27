---
name: companion
description: >
  Use when managing companion context — showing current companion, switching companions,
  or creating new ones. Triggers on any mention of setting, switching, creating, or listing companions.
disable-model-invocation: true
argument-hint: "[client/companion] or [new client/companion]"
---

# /companion — Manage Companion Context

Set, show, or create the current companion context.

**Usage:** `/companion`, `/companion [client/companion]`, `/companion new [client/companion]`

---

## Parse Arguments

Parse `$ARGUMENTS` to determine the mode:

- Empty → Mode 1 (Show)
- Contains path like `client/companion` without "new" → Mode 2 (Set)
- Starts with `new ` → Mode 3 (Create)

---

## Mode 1: No Arguments (Show)

1. **Read current companion** from `tracking/current-companion.md`
   - If file contains a companion path (like `acme-corp/api-service`), that's the current companion
   - If file says "No companion currently set" or is empty, there's no current companion

2. **List all companions** by scanning the `companions/` directory:
   - List each client directory
   - Under each client, list each companion
   - Mark the current companion with `*` if one is set

3. **Display** in this format:
   ```
   Current companion: [client/companion] (or "None")

   Available companions:
     [client-a]/
       * [companion-1]    <- current
       [companion-2]
     [client-b]/
       [companion-3]
   ```

   If no companions exist yet:
   ```
   Current companion: None

   No companions yet. Create one with:
     /companion new [client/companion]
   ```

---

## Mode 2: Set Current (client/companion argument, no "new")

1. **Verify the companion exists** at `companions/[client]/[companion]/`
   - If it doesn't exist, report the error and list available companions
   - Suggest: "Did you mean `/companion new [client/companion]` to create it?"

2. **Update `tracking/current-companion.md`** with just the companion path:
   ```
   client/companion
   ```
   (Replace the entire file contents with just this line)

3. **Confirm** the change:
   ```
   Current companion set to: [client/companion]
   ```

---

## Mode 3: Create New (starts with "new")

1. **Parse the companion path** from the rest of the arguments
   - Expected format: `new client/companion`
   - If format is wrong, show usage help

2. **Validate the path**:
   - Must contain exactly one `/`
   - Client and companion names should be lowercase, alphanumeric with hyphens
   - If invalid, explain the expected format

3. **Check if it already exists** at `companions/[client]/[companion]/`
   - If it exists, ask if user wants to set it as current instead
   - Don't recreate existing companions

4. **Create the companion directory structure**:
   ```bash
   mkdir -p companions/[client]/[companion]
   ```

5. **Initialize git repository** in the companion directory:
   ```bash
   cd companions/[client]/[companion] && git init
   ```

6. **Create initial context directory**:
   ```bash
   mkdir -p companions/[client]/[companion]/context
   ```

7. **Create the client's companion-kit directory** (if it doesn't exist):
   ```bash
   mkdir -p companion-kits/private-kits/[client]-companion-kit/personas
   mkdir -p companion-kits/private-kits/[client]-companion-kit/capabilities
   mkdir -p companion-kits/private-kits/[client]-companion-kit/library
   ```

8. **Update `tracking/current-companion.md`** with the new companion path

9. **Add entry to `tracking/projects-log.md`**:
   - Add a row to the Active Projects table
   - Set status to `seeding`
   - Set created date to today
   - Leave last session and notes empty

10. **Confirm** the creation:
    ```
    Created new companion: [client/companion]

    Directory: companions/[client]/[companion]/
    Companion kit: companion-kits/private-kits/[client]-companion-kit/
    Status: seeding

    Next steps:
      /intake    — Start capturing requirements
      /process   — Feed in existing documents or transcripts
    ```

---

## Error Handling

- If arguments don't match any mode, show usage help
- If companion path is malformed, explain the expected format
- If directory operations fail, report the error clearly
