---
globs: ["**/tickets.yaml"]
---

Use snake_case for all field names (blocked_by, input_files, output_files, acceptance_criteria, linear_id, spec_file, project_path, project_name, linear_parent_issue).

Ticket size is "S" or "M" only. Ticket titles use imperative form ("Create X", "Build Y").

Each ticket has at least one output_files entry and at least one acceptance_criteria entry.

Ticket IDs are sequential integers (1, 2, 3). The blocked_by field is a list of ticket IDs or empty [].

Status values: pending, in_progress, completed, skipped.
