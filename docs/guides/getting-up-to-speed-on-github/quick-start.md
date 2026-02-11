# Git & GitHub Quick Start

**Time**: 30-45 minutes for core setup
**Goal**: Get you cloning, committing, and pushing to GitHub

---

## The Absolute Essentials

### Step 1: Install Git (5-10 minutes)

**Check if you have Git**:
```bash
git --version
```

**If you see "command not found", install it**:
```bash
xcode-select --install
```

Click "Install" in the popup, wait 5-10 minutes, then verify:
```bash
git --version
```

**Configure Git**:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

### Step 2: Set Up GitHub Account (5 minutes)

1. Go to [github.com](https://github.com) and sign up
2. Use your work email
3. Choose a professional username
4. Enable 2FA (Settings → Password and authentication → Two-factor authentication)

**Create organization** (for professional work):
1. Click profile picture → "Your organizations"
2. Click "New organization" → "Create a free organization"
3. Choose organization name (e.g., `acme-corp`, `your-company`)

---

### Step 3: Set Up SSH Keys (15-20 minutes)

**Why?** GitHub doesn't accept passwords anymore. SSH keys are a one-time setup for secure authentication.

**Generate key**:
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
```

- Press Enter (default location)
- Create a passphrase (you'll only type this once if you do the next step)
- Press Enter again

**Add to Mac keychain** (so you never retype passphrase):
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Create config file** (makes keychain permanent):
```bash
cat >> ~/.ssh/config << 'EOF'
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
```

**Copy public key**:
```bash
cat ~/.ssh/id_ed25519.pub | pbcopy
```

(Your public key is now copied to clipboard)

**Add to GitHub**:
1. Go to [github.com](https://github.com) → Settings
2. Click "SSH and GPG keys" (left sidebar)
3. Click "New SSH key"
4. Title: "My MacBook" (or whatever)
5. Paste (`Cmd+V`) your key
6. Click "Add SSH key"

**Test it works**:
```bash
ssh -T git@github.com
```

First time, you'll see a warning—type `yes` and press Enter.

**Success looks like**:
```
Hi yourname! You've successfully authenticated...
```

---

### Step 4: Clone Project Creator (5 minutes)

**Create a dev folder**:
```bash
mkdir -p ~/dev
cd ~/dev
```

**Clone the repository**:
```bash
git clone git@github.com:Consortium-team/project-creator.git
```

**Verify**:
```bash
ls ~/dev/project-creator
```

You should see: `CLAUDE.md`, `README.md`, `.claude/`, `projects/`, etc.

---

### Step 5: Daily Workflow (5 minutes)

**The four-command loop**:

```bash
cd ~/dev/project-creator          # 1. Go to your project

git status                         # 2. See what changed

git add .                          # 3. Stage all changes

git commit -m "Descriptive message about what you did"  # 4. Commit

git push                           # 5. Upload to GitHub
```

**Example**:
```bash
cd ~/dev/project-creator
# (make some changes to files)
git status
git add .
git commit -m "Add client profile and intake notes"
git push
```

---

## Commit Message Template

Complete this sentence: **"This commit will..."**

**Good**:
- ✅ "Add initial requirements from client intake session"
- ✅ "Update contact information and project terms"
- ✅ "Fix typo in CLAUDE.md"

**Bad**:
- ❌ "Updated stuff"
- ❌ "WIP"
- ❌ "asdf"

---

## Common Errors & Quick Fixes

| Error | Fix |
|-------|-----|
| **"Permission denied (publickey)"** | SSH key not added to GitHub—redo Step 3 |
| **"fatal: not a git repository"** | You're not in the right folder—run `cd ~/dev/project-creator` |
| **"Your branch is behind 'origin/main'"** | Someone else pushed changes—run `git pull` |
| **"Nothing to commit, working tree clean"** | No changes since last commit (this is fine!) |

---

## When You're Stuck

**Before asking for help**:
1. Run `git status` and read the output
2. Copy the EXACT error message
3. Google: "git [your error message]"

**Ask for help with**:
- What you were trying to do
- The exact command you ran
- The complete error message
- Output of `git status`

---

## Next Steps

Once you're comfortable with the basics (2-3 weeks):
- Read the full guide: `getting-up-to-speed-on-github.md`
- Learn about branches (for experimental work)
- Use Claude Code to automate routine Git tasks

---

## Daily Habit

**End of every work session**:
```bash
cd ~/dev/project-creator
git add .
git commit -m "End of session: [what you worked on]"
git push
```

**Start of every work session**:
```bash
cd ~/dev/project-creator
git pull  # Get latest changes
```

This prevents conflicts and keeps your work safe.

---

## That's It!

You now know enough Git to use Project Creator effectively. Everything else is refinement.

**Questions?** Check the full guide or ask Claude Code.
