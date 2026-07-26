---
name: calendar-scheduler
description: Use when any date, deadline, appointment, meeting, class, work task, exam, interview, reservation, reminder, recurring schedule, or calendar cleanup should be registered, updated, checked, normalized, or reasoned about in Google Calendar. Supports personal, university, work, and job-hunt schedules. Creates safe calendar event drafts/writes, checks conflicts and duplicates, chooses reminders, protects sensitive details, and, in project contexts such as job-hunt, rolls facts into the appropriate local records.
---

# Calendar Scheduler

## Role

Register, update, inspect, and reason about calendar events with operational reliability. Use it for Google Calendar tasks across personal life, university, work, and job hunting.

In this `job-hunt` project, this skill also complements `job-tracker`: calendar writes are never enough by themselves when the event affects applications or selection progress.

## Operating Principles

- Treat calendar writes as state changes, not notes.
- Normalize dates before reasoning. Use exact weekday, date, time, and timezone.
- Read bounded calendar state before writing when duplicates or conflicts are possible.
- Preserve existing event data unless the user asked to change it.
- Prefer clear event titles, structured descriptions, and explicit reminders over vague blocks.
- Store only operationally useful information in Calendar.
- Record durable facts in the system of record for the context:
  - job hunting: `tracker.md`, company files, `todo.html`, work log
  - university/work/personal: use the relevant local notes only if they exist or the user asks

## Trigger Examples

Use this skill for:

- "この締切をカレンダーに入れて"
- "面接日程を登録して"
- "テストセンター予約をカレンダーに入れて"
- "明日の空き時間を見て"
- "この予定と被ってない？"
- "授業/課題/仕事の期限を入れて"
- "Google Calendar登録フローを整えたい"
- "古いリマインダーを整理したい"
- "この予定を変更して"

## Core Workflow

1. Extract exact facts:
   - title target, event type, date, start/end, timezone
   - deadline strictness or flexibility
   - location / online meeting / required equipment
   - participants, if any
   - source of truth
   - remaining action
2. Normalize relative dates to absolute datetimes. In Japan contexts, default to `Asia/Tokyo` unless evidence says otherwise.
3. Classify the event using `references/event-types.md`.
4. Read bounded Google Calendar state before writes:
   - deadlines: search now through 7 days after deadline
   - fixed events: search 2 days before through 2 days after
   - recurring or cleanup requests: search a bounded window such as next 30 days
5. Check local context when a project has local records. In this repository, check:
   - `tracker.md`
   - relevant `companies/<path>/questions.md`
   - relevant `companies/<path>/research.md`
   - `notes/todos/todo.html`
   - current day `notes/作業アーカイブ/YYYY-MM-DD_作業ログ.md`
6. Choose event title, transparency, reminders, and description.
7. Validate event data when it is high-stakes or complex.
8. Create or update the Google Calendar event.
9. Roll durable facts into local records when applicable.
10. Report final event details, remaining tasks, and any uncertainty.

## When to Read References

- Read `references/event-types.md` before choosing title, event duration, transparency, and local rollup target.
- Read `references/reminder-policy.md` before setting reminders.
- Read `references/privacy-policy.md` before placing user identifiers, URLs, test IDs, addresses, or application details in event descriptions.
- Read `references/examples.md` when drafting event descriptions or resolving ambiguous job-hunt cases.

## Event Design

### Title

Use a compact title with an intent prefix:

| Prefix | Use |
|---|---|
| `【締切】` | hard deadline |
| `【就活】` | job-hunt operational event |
| `【面接】` | interview |
| `【選考】` | selection event that is not a normal interview |
| `【授業】` | class |
| `【課題】` | university assignment deadline/work block |
| `【仕事】` | work meeting/task |
| `【確認】` | check/reminder |
| `【予定】` | personal/general |

Use the user's naming style if clear.

### Time Block

- Hard deadline: event ends exactly at the deadline.
- Physical event: include arrival/travel/prep buffer when known.
- Online meeting/test: include setup buffer when needed.
- Check/reminder: 15-30 minutes.
- Work block: duration requested by user; if unspecified, ask or use a clearly stated default.

### Transparency

- Transparent: deadlines, checks, reminders.
- Busy/opaque: meetings, tests, interviews, classes, travel, reserved work blocks.

### Description

Write descriptions in plain bullet form:

- source / purpose
- exact deadline or start time
- required actions
- requirements
- remaining task
- local record path or event ID only when useful

Do not put secrets or long essays in descriptions.

## Scripts

- Use `scripts/build_event_description.py` to generate consistent calendar descriptions from a small JSON payload.
- Use `scripts/validate_event_payload.py` before calendar writes when event data is complex or high-stakes.

Both scripts use only the Python standard library and print to stdout. They do not call Google Calendar directly.

## Write Safety

- Prefer updating an existing matching event over creating duplicates.
- For strict deadlines, create transparent deadline blocks ending at the exact deadline.
- For physical tests/interviews/classes/meetings, create busy events covering arrival/prep buffer through expected end.
- Do not include sensitive IDs, registration numbers, full personal addresses, phone numbers, or ES answers in Calendar.
- Do not delete calendar events unless the user explicitly asks.
- If the connector is unavailable, draft the exact event payload and still update local records.
- If the event affects another person, preserve attendees and meeting links unless explicitly changing them.
- If a write is broad, destructive, or recurring, show the intended diff first.

## Local Rollup in This Repository

For job-hunt facts, always update local records after a calendar action:

| Fact | Local target |
|---|---|
| New deadline or changed deadline | `tracker.md`, company `questions.md`, `notes/todos/todo.html`, work log |
| Test center / interview / event reservation | `tracker.md`, company `questions.md`, work log |
| Submitted ES / completed Web test / result wait | `tracker.md`, company `questions.md`, `notes/todos/todo.html`, work log |
| Calendar event ID | company `questions.md` or work log; `tracker.md` memo when useful |

For non-job-hunt facts, update local records only when a relevant notes system exists or the user asks. Do not invent a project structure for unrelated calendars inside this repository.

## Conflict Handling

- Surface direct overlaps.
- Surface near conflicts when travel/setup time is likely needed.
- Distinguish real conflicts from transparent reminders.
- If the user must choose among slots, rank options by conflict risk, deadline safety, and cognitive load.
- If a task was postponed, update todo/work log but do not move externally imposed deadlines.

## Failure Handling

- If Google Calendar connector is unavailable, produce a ready-to-create payload with title, start/end, timezone, description, reminders, transparency, visibility.
- If a referenced page or URL times out, record that the URL was inaccessible and ask the user to paste the visible rule text.
- If exact time is missing, create no write unless a safe default is obvious from context or precedent.
- If the user shares sensitive IDs, exclude them from Calendar and record only non-sensitive operational details.

## Completion Report

Report:
- event title, exact date/time/timezone, transparency/busy status, reminder lead times, and event ID
- local files updated
- remaining next action
- any duplicate/conflict/uncertainty found
