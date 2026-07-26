# Reminder Policy

Use structured Google Calendar reminders.

| Event risk | Reminder overrides |
|---|---|
| Strict deadline within 7 days | popup 48h, 24h, 3h, 1h |
| Strict deadline more than 7 days away | popup 7d, 48h, 24h, 3h |
| Test center / physical interview | popup 24h, 3h, 1h |
| Online Web test reservation | popup 24h, 3h, 1h |
| Result check / MyPage check | popup 24h, 1h |
| Low-priority info session | popup 24h, 1h or default reminders |
| University assignment deadline | popup 48h, 24h, 3h, 1h when close; otherwise 7d, 48h, 24h |
| Work deadline | popup 48h, 24h, 3h, 1h when close |
| Work meeting / class | default reminders or popup 30m/10m if user prefers |
| Personal appointment with travel | popup 24h, 3h, 1h |
| Focus/work block | default reminders or none |

## Escalation Rules

- If a deadline is strict and missing the action means disqualification, state `厳守` in the description.
- If ES is submitted but Web test remains, keep the deadline event until Web test completion is confirmed.
- If the user postpones work, update todo/work log but do not move externally imposed deadlines.
- If the deadline is user-imposed, make that clear and avoid overstating external consequences.
- If a reminder is for preparation rather than the final deadline, title it `【確認】` or `【作業】`, not `【締切】`.

## Calendar Fields

- Use `visibility: private` for job-hunt events by default.
- Use `visibility: private` for personal-sensitive, job-hunt, medical, or financial events by default.
- Use `transparency: transparent` for deadlines and checks.
- Use `transparency: opaque` for interviews, tests, internships, classes, appointments, meetings, and reserved work blocks that consume time.
- Avoid adding Google Meet unless the event is explicitly an online meeting requiring one.
