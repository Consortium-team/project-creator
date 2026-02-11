#!/bin/bash

# Generate PDF from Markdown guide
# Usage: ./generate-pdf.sh

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_MD="$SCRIPT_DIR/getting-up-to-speed-on-github.md"
OUTPUT_PDF="$SCRIPT_DIR/getting-up-to-speed-on-github.pdf"

echo "🔧 Generating PDF from Markdown guide..."
echo "Source: $SOURCE_MD"
echo "Output: $OUTPUT_PDF"

# Check if source exists
if [ ! -f "$SOURCE_MD" ]; then
    echo "❌ Error: Source Markdown file not found: $SOURCE_MD"
    exit 1
fi

# Check for Pandoc (preferred method)
if command -v pandoc &> /dev/null; then
    echo "✅ Using Pandoc for PDF generation"

    # Pandoc options:
    # --pdf-engine=xelatex: Better Unicode/font support
    # --toc: Generate table of contents
    # --toc-depth=2: Include up to H2 headings in TOC
    # -V geometry:margin=1in: 1-inch margins
    # -V linkcolor=blue: Hyperlinks in blue
    # -V urlcolor=blue: URLs in blue
    # --highlight-style=tango: Syntax highlighting for code blocks

    pandoc "$SOURCE_MD" \
        -o "$OUTPUT_PDF" \
        --pdf-engine=xelatex \
        --toc \
        --toc-depth=2 \
        -V geometry:margin=1in \
        -V linkcolor=blue \
        -V urlcolor=blue \
        -V mainfont="SF Pro" \
        -V monofont="SF Mono" \
        --highlight-style=tango \
        --metadata title="Getting Started with Git & GitHub" \
        --metadata author="Sonjaya Tandon (Consortium.team)" \
        --metadata date="February 2026"

    echo "✅ PDF generated successfully: $OUTPUT_PDF"

elif command -v markdown-pdf &> /dev/null; then
    echo "✅ Using markdown-pdf for PDF generation"

    markdown-pdf "$SOURCE_MD" -o "$OUTPUT_PDF"

    echo "✅ PDF generated successfully: $OUTPUT_PDF"

else
    echo "❌ Error: No PDF generation tool found"
    echo ""
    echo "Please install one of the following:"
    echo ""
    echo "Option 1: Pandoc (Recommended)"
    echo "  brew install pandoc"
    echo "  brew install basictex  # For LaTeX engine"
    echo ""
    echo "Option 2: markdown-pdf (Node.js)"
    echo "  npm install -g markdown-pdf"
    echo ""
    echo "Option 3: Use Marked 2 (Mac app)"
    echo "  Download from: https://marked2app.com/"
    echo "  Open $SOURCE_MD in Marked 2"
    echo "  File → Export as PDF"
    echo ""
    exit 1
fi

# Verify PDF was created
if [ -f "$OUTPUT_PDF" ]; then
    FILE_SIZE=$(du -h "$OUTPUT_PDF" | cut -f1)
    echo "📄 PDF size: $FILE_SIZE"
    echo "🎉 Done! PDF ready for distribution."
else
    echo "❌ Error: PDF generation failed"
    exit 1
fi
