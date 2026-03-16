---
name: start-huddle
description: Start a multi-companion huddle in Slack. Creates a thread in the huddle channel, posts an opening perspective, and launches a background polling agent. Use when a topic needs multiple companion perspectives in conversation.
disable-model-invocation: true
argument-hint: "[Topic] Participants: [P1, P2, P3] Channel: #channel-name (optional)"
---

# /start-huddle — Start a Multi-Companion Huddle

Create a Slack thread for asynchronous multi-companion discussion and begin polling for responses.

## Argument: $ARGUMENTS

The huddle topic and participant list.

Examples:
```
/start-huddle Designing the Data Architect Participants: EA, KE, KA, PS
/start-huddle Capability kit architecture review Participants: EA, PC
/start-huddle Onboarding flow redesign Participants: KA, KE
/start-huddle Cross-team alignment Participants: EA, KA Channel: #imaginesports
```

---

## Step 1: Parse Arguments

If `Channel: #[name]` appears in `$ARGUMENTS`, extract it and remove it before parsing topic/participants.

Extract from `$ARGUMENTS`:
- `topic` — everything before "Participants:"
- `participants` — comma-separated short names after "Participants:"

If no "Participants:" found, ask:
```
Who should participate? List companion short names (e.g., EA, KA, KE, PS, PC).
```

Declare:
```
Topic: [topic]
Participants: [list]
```

Declare (if Channel provided):
```
Channel override: #[name]
```

---

## Step 2: Read Channel Configuration

If a `Channel:` override was provided in Step 1, use `slack_search_channels` with the channel name to resolve the channel ID. Skip reading `tracking/huddle-channel.md`.

Otherwise, read `tracking/huddle-channel.md` to get the channel name and channel ID.

If the file does not exist:
```
Huddle channel not configured. Create tracking/huddle-channel.md with:
- Channel: #[channel-name]
- Channel ID: [Slack channel ID]
```
**Stop here.**

Declare:
```
Channel: [name]
Channel ID: [id]
```

---

## Step 3: Create the Huddle Thread

Post the thread header to the huddle channel:

```
**Huddle: [Topic]**
Participants: [comma-separated short names]
Started by: Practitioner
Status: Open

Context: [2-3 sentence framing — draw from the current conversation context to explain what we're trying to decide or discuss]
```

Use `slack_send_message` to post this to the channel. Capture the thread timestamp from the response — this is the `thread_ts` for all subsequent messages.

---

## Step 4: Post Opening Perspective

Post this companion's (PC) opening perspective as a reply in the thread:

```
From: PC | To: all — [Opening perspective on the topic, drawing from companion design methodology, capability architecture, or ecosystem topology expertise as relevant]
```

Use `slack_send_message` with the `thread_ts` from Step 3.

---

## Step 5: Launch Polling Agent

Launch a background sub-agent to poll the thread for new messages.

Agent briefing:
- **Identity:** PC (Project Creator) — expertise in companion design methodology, capability architecture, ecosystem topology, reverse prompting
- **Huddle topic:** [topic]
- **Channel ID:** [channel ID]
- **Thread timestamp:** [thread_ts from Step 3]
- **Last seen timestamp:** [timestamp of the opening perspective message]

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
Huddle started: [Topic]
Thread: [Slack thread link or channel + thread_ts]
Participants: [list]
Polling active — I'll monitor for 30 minutes or until closed.

Next: run /join-huddle in each participating companion's session.
```
