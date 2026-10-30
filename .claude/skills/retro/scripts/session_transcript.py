#!/usr/bin/env python3
"""Condense a Claude Code session transcript for writing a retro log.

Writes a Markdown file with every user prompt verbatim (harness wrappers removed, slash commands shown as typed,
pasted text and attachments marked with their size), and under each, the assistant's text replies in full and any
AskUserQuestion questions with their options. System messages (skill bodies, compaction summaries, task
notifications, hook output) are left out. The /retro skill reads this file to write the retro log.

Usage:
  python3 session_transcript.py --out /path/condensed.md                  # the current (most recent) session
  python3 session_transcript.py --session <uuid> --out ...                # a specific session
  python3 session_transcript.py --since 2026-10-28T14:00 [--until ...] --out ...   # a time window, any sessions

Transcripts are read from ~/.claude/projects/<encoded project root>/. The project root defaults to the current
directory; if no transcript folder exists for it, parent directories are tried (pass --root to override).
Times are local unless they carry an offset.
"""
import argparse
import datetime as dt
import glob
import json
import os
import re

SKIP_PREFIXES = ("Base directory for this skill", "This session is being continued", "Another Claude session",
                 "<task-notification>", "<system-reminder>", "Caveat:", "<local-command-")
LONG_PASTE = 1500  # characters; longer pasted blocks are flagged for summarizing


def parse_time(s):
    t = dt.datetime.fromisoformat(s.replace("Z", "+00:00"))
    return t if t.tzinfo else t.astimezone()


def transcript_dir(root):
    path = os.path.abspath(root)
    while True:
        d = os.path.expanduser("~/.claude/projects/" + re.sub(r"[^A-Za-z0-9]", "-", path))
        if os.path.isdir(d):
            return d
        parent = os.path.dirname(path)
        if parent == path:
            raise SystemExit(f"No transcript folder found for {root} or its parents")
        path = parent


def mark_pastes(text):
    def repl(m):
        body = m.group(2)
        flag = f" — {len(body):,} chars, SUMMARIZE" if len(body) > LONG_PASTE else ""
        return f"[pasted text{flag}]\n{body}\n[end of pasted text]"
    return re.sub(r'<pasted_content id="([^"]*)">\n?(.*?)\n?</pasted_content id="\1">', repl, text, flags=re.S)


def clean(text):
    text = mark_pastes(text)
    return re.sub(r"<command-message>[^<]*</command-message>\s*<command-name>([^<]*)</command-name>"
                  r"(?:\s*<command-args>(.*?)</command-args>)?",
                  lambda m: (m.group(1) + " " + (m.group(2) or "")).strip(), text, flags=re.S)


def user_text(content):
    if isinstance(content, str):
        return content.strip(), []
    texts, attachments = [], []
    for x in content or []:
        if not isinstance(x, dict):
            continue
        kind = x.get("type")
        if kind == "text":
            texts.append(x.get("text", ""))
        elif kind in ("image", "document"):
            src = x.get("source", {})
            size = len(src.get("data", "") or "")
            attachments.append(f"[attachment: {kind}{', ' + src.get('media_type') if src.get('media_type') else ''}"
                               f"{f', ~{size * 3 // 4 // 1024} KB' if size else ''} — SUMMARIZE]")
    return "\n".join(texts).strip(), attachments


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--session", help="session uuid (the transcript file name without .jsonl)")
    ap.add_argument("--since")
    ap.add_argument("--until")
    ap.add_argument("--root", default=os.getcwd())
    a = ap.parse_args()
    tdir = transcript_dir(a.root)

    if a.since:
        files = glob.glob(os.path.join(tdir, "*.jsonl"))
    elif a.session:
        files = [os.path.join(tdir, a.session + ".jsonl")]
    else:
        files = sorted(glob.glob(os.path.join(tdir, "*.jsonl")), key=os.path.getmtime)[-1:]
    since = parse_time(a.since) if a.since else None
    until = parse_time(a.until) if a.until else None

    entries, seen = [], set()
    for path in files:
        if since and dt.datetime.fromtimestamp(os.path.getmtime(path)).astimezone() < since:
            continue
        for line in open(path, encoding="utf-8"):
            try:
                o = json.loads(line)
            except ValueError:
                continue
            if (o.get("isSidechain") or o.get("isMeta") or o.get("isCompactSummary")
                    or o.get("type") not in ("user", "assistant") or not o.get("timestamp")):
                continue
            t = parse_time(o["timestamp"])
            if (since and t < since) or (until and t > until) or o.get("uuid") in seen:
                continue
            seen.add(o.get("uuid"))
            entries.append((t, o))
    entries.sort(key=lambda e: e[0])

    out, n, last_prompt, first, last = [], 0, None, None, None
    for t, o in entries:
        content = o.get("message", {}).get("content")
        local = t.astimezone()
        if o["type"] == "user":
            text, attachments = user_text(content)
            if not text and not attachments:
                continue
            if text.startswith(SKIP_PREFIXES):
                continue
            if text.startswith("[Request interrupted"):
                out.append("\n[INTERRUPTED by the user]\n")
                continue
            text = clean(text)
            dup = text == last_prompt
            last_prompt = text
            n += 1
            first = first or local
            last = local
            body = "\n".join(filter(None, [text] + attachments))
            out.append(f"\n\n######## PROMPT {n} ({local:%Y-%m-%d %H:%M})"
                       f"{' [same text as the previous prompt]' if dup else ''}\n~~~~text\n{body}\n~~~~\n")
        else:
            for x in content or []:
                if not isinstance(x, dict):
                    continue
                if x.get("type") == "text" and x["text"].strip():
                    out.append(f"\n[REPLY {local:%H:%M}] " + x["text"].strip() + "\n")
                    last = local
                elif x.get("type") == "tool_use" and x["name"] == "AskUserQuestion":
                    for q in x["input"].get("questions", []):
                        opts = "\n".join(f"  - {op.get('label')}: {op.get('description', '')}"
                                         for op in q.get("options", []))
                        out.append(f"\n[ASKED] {q.get('question', '')}\n{opts}\n")
                elif x.get("type") == "tool_use" and x["name"] in ("Write", "Agent", "Skill"):
                    i = x["input"]
                    out.append(f"\n[{x['name'].upper()}] "
                               + (i.get("file_path") or i.get("description") or i.get("skill", "")) + "\n")

    span = f"{first:%Y-%m-%d %H:%M} to {last:%Y-%m-%d %H:%M}" if first else "no prompts"
    with open(a.out, "w", encoding="utf-8") as f:
        f.write(f"# Condensed session transcript ({span}, local time)\n"
                f"Source: {', '.join(os.path.basename(p) for p in files)}\n" + "".join(out))
    print(f"prompts {n} · entries {len(entries)} · {span} · wrote {a.out}")


if __name__ == "__main__":
    main()
