# Supplementary Diagrams

This directory contains visual diagrams referenced in Appendix C of `getting-started-git-github.md`.

## Required Diagrams (3)

### 1. workflow-diagram.png
**Purpose**: Visualize the basic Git workflow: Edit → Stage → Commit → Push

**Content**:
- Five boxes connected by arrows:
  1. Working Directory (files on computer)
  2. Staging Area (selected for commit)
  3. Local Repository (committed history)
  4. Remote/GitHub (backup)
- Commands labeled on arrows: `git add`, `git commit`, `git push`
- Different colors for each stage
- Icons: 📝 (working), ✅ (staging), 📦 (local), ☁️ (remote)

**Style**: Clean, professional diagram (use draw.io, Figma, or similar)

### 2. git-github-relationship.png
**Purpose**: Show relationship between local Git and remote GitHub

**Content**:
- Two main sections:
  - **Local (Your Computer)**: Working Directory + Git Repository (.git folder)
  - **Remote (GitHub)**: Remote Repository (backup + collaboration)
- Bidirectional arrows labeled "git push / git pull"
- Clear visual separation between local and remote

**Style**: Architecture-style diagram with boxes and connecting lines

### 3. photo-album-analogy.png
**Purpose**: Visual representation of the photo album metaphor from Part 1

**Content**:
- Four stages illustrated:
  1. **Photos on desk** (📷 icons scattered) → Working Directory
  2. **Selected photos** (✅ icons) → Staging Area
  3. **Album page with caption** (📖 icon) → Local Repository
  4. **Backup album at facility** (🏛️ icon) → GitHub
- Commands between stages: `git add`, `git commit`, `git push`
- Friendly, approachable visual style

**Style**: Illustration-style diagram (can use icons/emoji for clarity)

## Design Standards

### Visual Consistency
- **Color palette**: Use consistent colors across all diagrams
  - Working Directory: Light blue (#E3F2FD)
  - Staging Area: Light yellow (#FFF9C4)
  - Local Repository: Light green (#C8E6C9)
  - Remote/GitHub: Light purple (#E1BEE7)
- **Font**: Sans-serif, readable (Helvetica, Arial, or SF Pro)
- **Arrow style**: Bold, clear directional indicators

### Technical Requirements
- **Format**: PNG with transparency where appropriate
- **Resolution**: High DPI (2x/Retina) for clarity
- **Dimensions**: Approximately 800-1200px wide (readable on screen and in PDF)

### Accessibility
- **Color contrast**: Ensure text is readable against backgrounds
- **Labels**: All boxes/sections clearly labeled
- **Alt text consideration**: Diagrams should be self-explanatory with minimal text

## Creation Tools

**Recommended tools**:
- **draw.io (diagrams.net)**: Free, browser-based, excellent for workflow diagrams
- **Figma**: Professional design tool, free tier available
- **Excalidraw**: Hand-drawn style, approachable for analogies
- **OmniGraffle**: Mac-native, professional diagramming
- **Keynote/PowerPoint**: Export slides as images (quick option)

## Production Workflow

1. **Create diagrams**: Use one of the recommended tools
2. **Export as PNG**: High resolution (2x)
3. **Verify clarity**: Check readability at normal viewing size
4. **Optimize file size**: Compress without quality loss (ImageOptim, TinyPNG)
5. **Place in directory**: Save as specified filenames
6. **Update guide**: Verify image references work in Markdown preview

## Status

**Current**: Placeholders referenced in guide
**Next step**: Create actual diagrams
**Priority**: Medium (guide is usable without these, but enhanced with visuals)
**Estimated time**: 2-3 hours
**Owner**: Sonjaya Tandon (or delegate to designer)

## Notes

- Diagrams should align conceptually with text in Appendix C
- Consider creating both light and dark mode versions if guide will be used in dark environments
- SVG format could be used for web version (scalable), but PNG is better for PDF
