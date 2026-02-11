# Getting Up to Speed on GitHub

A comprehensive guide for non-technical Project Creator users.

---

## What's This?

This guide teaches the minimal Git and GitHub knowledge needed to use Project Creator independently—without needing to become a Git expert.

**Who it's for**: Product managers, executives, strategists, and other non-technical professionals who need to manage project files and collaborate via GitHub.

**Time commitment**: 2-3 hours for initial setup; 2-5 minutes daily once established.

---

## Quick Start

Need to get going immediately? Start with [`quick-start.md`](quick-start.md) (30-45 minutes).

It covers the absolute essentials:
1. Install Git (5-10 min)
2. Set up GitHub account (5 min)
3. Set up SSH keys (15-20 min)
4. Clone Project Creator (5 min)
5. Daily workflow (5 min)

---

## Full Guide

For comprehensive learning, see [`getting-up-to-speed-on-github.md`](getting-up-to-speed-on-github.md) or the [PDF version](getting-up-to-speed-on-github.pdf) (once generated).

### Contents

**10 Parts**:
1. Understanding Git & GitHub (Concepts) — Photo album analogy
2. Mac Terminal Basics — Opening, navigating
3. Installation & Setup — Git installation, configuration
4. GitHub Account & Organization Setup — Professional setup
5. SSH Keys (The Authentication Bridge) — Secure authentication
6. Cloning Project Creator — Downloading the repository
7. Basic Git Hygiene — Daily workflow, commit messages
8. Collaborator Management — Adding team members
9. Claude Code Integration — Automating Git tasks
10. Troubleshooting & Getting Help — Common errors, self-help

**4 Appendices**:
- A. Command Quick Reference
- B. Glossary
- C. Visual Workflow Diagrams
- D. Further Resources

---

## Generating the PDF

### Prerequisites

Install Pandoc and LaTeX:
```bash
brew install pandoc
brew install basictex
```

### Generate

```bash
./generate-pdf.sh
```

The script will create `getting-up-to-speed-on-github.pdf` with professional formatting.

---

## Directory Structure

```
getting-up-to-speed-on-github/
├── README.md                                # This file
├── getting-up-to-speed-on-github.md         # Master guide (Markdown)
├── getting-up-to-speed-on-github.pdf        # Generated PDF
├── quick-start.md                           # Quick 30-45 min setup
├── generate-pdf.sh                          # PDF generation script
├── screenshots/                             # Screenshot assets
│   └── README.md                            # Screenshot capture guide
└── supplementary/                           # Diagram assets
    └── README.md                            # Diagram creation guide
```

---

## Contributing

Found an error or have a suggestion?

### Report Issues
Create an issue in the [Project Creator repository](https://github.com/Consortium-team/project-creator/issues)

### Submit Improvements
1. Fork the repository
2. Make your changes to the Markdown file
3. If you update `getting-up-to-speed-on-github.md`, run `./generate-pdf.sh` to regenerate the PDF
4. Submit a pull request

### Adding Screenshots or Diagrams
See `screenshots/README.md` and `supplementary/README.md` for specifications and standards.

---

## Maintenance

This guide is reviewed quarterly for:
- GitHub UI changes (screenshot updates needed?)
- macOS updates (installation steps still valid?)
- Git version changes (commands still work?)

**Last Review**: February 2026

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-10 | Initial open-source release for Project Creator |

---

## License

MIT License — Free to use, modify, and distribute.

See [Project Creator LICENSE](../../../LICENSE) for details.

---

## Credits

**Originally created for**: Consortium.team clients (ImagineSports, 7TWorld)

**Contributed to Project Creator as**: Open-source resource

**Maintained by**: Project Creator community
