---
name: join-huddle
description: Join an existing multi-companion huddle in Slack. Reads the thread, posts an opening perspective, and launches a background polling agent. Use when another companion started a huddle and this companion should participate.
disable-model-invocation: true
argument-hint: "[thread-link or thread-ts] Channel: #channel-name (optional)"
---

# /join-huddle — Join an Existing Huddle

Read an active huddle thread, post an opening perspective, and begin polling.

## Argument: $ARGUMENTS

A Slack thread link or thread timestamp identifying the huddle to join.

Examples:
```
/join-huddle https://softwarecurmudgeons.slack.com/archives/C07T8B65ZM4/p1234567890
/join-huddle 1234567890.123456
/join-huddle 1234567890.123456 Channel: #imaginesports
```

---

## Step 1: Resolve the Thread

First, extract optional `Channel: #[name]` from end of `$ARGUMENTS` and remove it before parsing the thread reference. If present, use `slack_search_channels` to resolve the channel ID instead of reading `tracking/huddle-channel.md`.

Parse `$ARGUMENTS` to extract the thread timestamp:
- If a Slack URL: extract the timestamp from the `p` parameter (e.g., `p1234567890` → `1234567890.000000`)
- If a raw timestamp: use as-is

If no Channel override was provided, read `tracking/huddle-channel.md` to get the channel ID.

If the file does not exist:
```
Huddle channel not configured. Create tracking/huddle-channel.md with:
- Channel: #[channel-name]
- Channel ID: [Slack channel ID]
```
**Stop here.**

Declare:
```
Channel ID: [id]
Thread timestamp: [ts]
```

---

## Step 2: Read the Thread

Use `slack_read_thread` with the channel ID and thread timestamp to read the full huddle conversation.

Extract:
- **Topic** — from the thread header (`Huddle: [Topic]`)
- **Participants** — from the header
- **Current state** — what's been discussed, any open questions, who said what
- **Whether the huddle is still open** — check for close signal

If the huddle is already closed:
```
This huddle is closed. Nothing to join.
```
**Stop here.**

Declare:
```
Topic: [topic]
Participants: [list]
Messages so far: [count]
```

---

## Step 3: Post Opening Perspective

Post this companion's (PC) opening perspective as a reply in the thread, informed by what's already been discussed:

```
From: PC | To: all — [Opening perspective that acknowledges what's been said and adds the companion design / capability architecture angle]
```

Do not repeat points already made. Add what's missing from PC's domain.

---

## Step 4: Launch Polling Agent

Launch a background sub-agent identical to the one in `/start-huddle`.

Agent briefing:
- **Identity:** PC (Project Creator) — expertise in companion design methodology, capability architecture, ecosystem topology, reverse prompting
- **Huddle topic:** [topic from Step 2]
- **Channel ID:** [channel ID]
- **Thread timestamp:** [thread_ts from Step 1]
- **Last seen timestamp:** [timestamp of PC's opening perspective from Step 3]
- **Conversation so far:** [brief summary of what's been discussed — enough for the agent to have context without carrying the full thread]

**Polling loop:**
1. Read channel with `limit: 1` to get latest message timestamp
2. Compare to last-seen timestamp
3. If same — sleep 30 seconds, loop back
4. If different — read full thread via `slack_read_thread`, determine if addressed or should contribute
5. If addressed (`To: PC` or `To: all` where PC has relevant input) — compose and post response following conversation norms
6. If close signal detected (`Huddle closed`) — post final summary if appropriate, exit loop
7. Safety timeout: exit after 30 minutes even if no close signal

**Conversation norms for the agent:**
- Respond when directly addressed (`To: PC`) or when the topic touches companion design and no one else has covered it
- Do NOT respond when the message is directed to someone else and you have nothing new to add
- Lead with position, then reasoning
- Reference specific capabilities, methodology principles, or prior decisions when relevant
- One main point per message

Report to the user:
```
Joined huddle: [Topic]
Thread: [Slack thread link or channel + thread_ts]
Messages so far: [count]
Polling active — I'll monitor for 30 minutes or until closed.
```
