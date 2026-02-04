# /project — Manage Project Context

Set, show, or create the current project context.

## Usage

```
/project                              # Show current + list all
/project [client/project]             # Set current (must exist)
/project new [client/project]         # Create new and set as current
```

## Argument: $ARGUMENTS

---

## Instructions

Parse the arguments to determine the mode:

### Mode 1: No Arguments (Show)

If `$ARGUMENTS` is empty:

1. **Read current project** from `tracking/current-project.md`
   - If file contains a project path (like `acme-corp/api-service`), that's the current project
   - If file says "No project currently set" or is empty, there's no current project

2. **List all projects** by scanning the `projects/` directory:
   - List each client directory
   - Under each client, list each project
   - Mark the current project with `*` if one is set

3. **Display** in this format:
   ```
   Current project: [client/project] (or "None")

   Available projects:
     [client-a]/
       * [project-1]    ← current
       [project-2]
     [client-b]/
       [project-3]
   ```

   If no projects exist yet:
   ```
   Current project: None

   No projects yet. Create one with:
     /project new [client/project]
   ```

---

### Mode 2: Set Current (client/project argument, no "new")

If `$ARGUMENTS` contains a path like `client/project` (no "new" prefix):

1. **Verify the project exists** at `projects/[client]/[project]/`
   - If it doesn't exist, report the error and list available projects
   - Suggest: "Did you mean `/project new [client/project]` to create it?"

2. **Update `tracking/current-project.md`** with just the project path:
   ```
   client/project
   ```
   (Replace the entire file contents with just this line)

3. **Confirm** the change:
   ```
   Current project set to: [client/project]
   ```

---

### Mode 3: Create New (starts with "new")

If `$ARGUMENTS` starts with `new `:

1. **Parse the project path** from the rest of the arguments
   - Expected format: `new client/project`
   - If format is wrong, show usage help

2. **Validate the path**:
   - Must contain exactly one `/`
   - Client and project names should be lowercase, alphanumeric with hyphens
   - If invalid, explain the expected format

3. **Check if it already exists** at `projects/[client]/[project]/`
   - If it exists, ask if user wants to set it as current instead
   - Don't recreate existing projects

4. **Create the directory structure**:
   ```bash
   mkdir -p projects/[client]/[project]
   ```

5. **Initialize git repository** in the project directory:
   ```bash
   cd projects/[client]/[project] && git init
   ```

6. **Create initial context directory**:
   ```bash
   mkdir -p projects/[client]/[project]/context
   ```

7. **Update `tracking/current-project.md`** with the new project path

8. **Add entry to `tracking/projects-log.md`**:
   - Add a row to the Active Projects table
   - Set status to `seeding`
   - Set created date to today
   - Leave last session and notes empty

9. **Confirm** the creation:
   ```
   Created new project: [client/project]

   Directory: projects/[client]/[project]/
   Status: seeding

   Next steps:
     /intake    — Start capturing requirements
     /process   — Feed in existing documents or transcripts
   ```

---

## Error Handling

- If arguments don't match any mode, show usage help
- If project path is malformed, explain the expected format
- If directory operations fail, report the error clearly
