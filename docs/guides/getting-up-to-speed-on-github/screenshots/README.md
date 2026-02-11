# Screenshots Directory

This directory contains screenshots referenced in `getting-started-git-github.md`.

## Required Screenshots (14 Critical)

### Terminal & Setup (5)
1. **terminal-spotlight.png** — Opening Terminal via Spotlight search
   - Show: Cmd+Space, "Terminal" typed, app highlighted
   - Annotations: None needed

2. **terminal-annotated.png** — Labeled Terminal window components
   - Show: Clean Terminal window with prompt
   - Annotations: Red boxes/arrows labeling prompt, command area, output area, cursor

3. **git-version-success.png** — Successful `git --version` output
   - Command: `git --version`
   - Expected output: `git version 2.39.2` (or similar)

4. **git-version-not-found.png** — Failed `git --version` when not installed
   - Command: `git --version`
   - Expected output: `zsh: command not found: git`

5. **xcode-install-dialog.png** — Xcode Command Line Tools installation popup
   - Trigger: `xcode-select --install`
   - Show: Dialog with Install/Cancel buttons

### Git Configuration (1)
6. **git-config-output.png** — Output of `git config --list`
   - Command: `git config --list`
   - Show: `user.name=...` and `user.email=...` entries

### SSH Setup (2)
7. **ssh-keygen-output.png** — SSH key generation process
   - Command: `ssh-keygen -t ed25519 -C "email@example.com"`
   - Show: Key fingerprint art and file locations

8. **ssh-test-success.png** — Successful GitHub SSH authentication
   - Command: `ssh -T git@github.com`
   - Expected: "Hi username! You've successfully authenticated..."

### GitHub Web UI (3)
9. **github-ssh-settings.png** — GitHub SSH keys settings page
   - Navigate: github.com → Settings → SSH and GPG keys
   - Show: "New SSH key" button and key list

10. **github-code-button-ssh.png** — Repository clone URL (SSH selected)
    - Navigate: Any GitHub repo → Code button
    - Show: SSH tab selected, `git@github.com:...` URL visible

11. **github-collaborators-settings.png** — Repository collaborators page
    - Navigate: Repo → Settings → Collaborators
    - Show: "Add people" button and permission options

### Git Operations (3)
12. **directory-listing-after-clone.png** — `ls` output after cloning
    - Command: `ls ~/dev/project-creator`
    - Show: CLAUDE.md, README.md, .claude/, projects/, etc.

13. **git-status-before-staging.png** — Changes before `git add`
    - Command: `git status` (with modified files)
    - Show: "Changes not staged for commit" section

14. **git-status-after-staging.png** — Changes after `git add`
    - Command: `git status` (after `git add .`)
    - Show: "Changes to be committed" section

15. **git-commit-success.png** — Successful commit output
    - Command: `git commit -m "Test message"`
    - Show: "[main abc1234] Test message" with file stats

## Screenshot Standards

### Technical Requirements
- **Resolution**: Retina/HiDPI (2x minimum)
- **Format**: PNG (lossless)
- **Terminal theme**: Use default macOS Terminal theme (white background) for consistency
- **Window size**: Comfortable reading size (not full-screen, not tiny)

### Content Guidelines
- **Redact personal info**: Replace real emails/names with examples where sensitive
- **Clean environment**: Close unnecessary tabs/windows in background
- **Consistent Terminal**: Use same Terminal appearance across all shots
- **Readable text**: Ensure font size is large enough for clarity

### Annotation Standards
- **Tool**: Use macOS Preview or similar for annotations
- **Colors**: Red for boxes/arrows (#FF0000)
- **Arrow style**: Bold, clear pointing
- **Text labels**: White text on red background for visibility
- **Minimal annotations**: Only annotate when necessary (terminal-annotated.png is the main example)

## Capture Workflow

1. **Clean Mac setup**: Create fresh user or use clean testing environment
2. **Capture raw screenshots**: Take all 14 screenshots following steps in guide
3. **Annotate**: Add annotations only where specified (mainly #2)
4. **Verify**: Check each screenshot matches guide references
5. **Optimize**: Compress PNGs if needed (without quality loss)
6. **Commit**: Add to git with descriptive commit message

## Missing Screenshots

Currently all screenshots are placeholders. Actual capture needed before distribution.

**Priority**: High (guide is incomplete without these)
**Estimated time**: 3-4 hours (including setup, capture, annotation, verification)
**Owner**: Sonjaya Tandon

## Notes

- GitHub UI screenshots should be captured on same day to ensure UI consistency
- Terminal screenshots can use dummy/example data (don't need real client repos)
- Consider capturing a few extra variants (light/dark mode) for accessibility
