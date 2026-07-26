# Event Types

Use this reference to classify calendar entries across personal, university, work, and job-hunt contexts.

| Type | Title pattern | Default time block | Transparency | Local stage impact |
|---|---|---|---|---|
| ES deadline | `【締切】<Company> ES提出` | last 60-90 min before deadline | transparent | `ES作成中` or `ES提出済み` after submission |
| ES + Web test deadline | `【締切】<Company> ES提出・WEBテスト受検` | last 90 min before deadline | transparent | `Webテスト/適性検査` if ES done but test remains |
| Web test deadline | `【締切】<Company> WEBテスト受検` | last 60-90 min before deadline | transparent | `Webテスト/適性検査` |
| Test center reservation | `【就活】<Company> <Test Name>（テストセンター）` | arrival buffer through expected end | busy | `Webテスト/適性検査` |
| Online proctored test | `【就活】<Company> WEBテスト（オンライン監督）` | setup buffer + test duration | busy | `Webテスト/適性検査` |
| Interview | `【面接】<Company> <Stage>` | prep buffer + interview duration | busy | matching interview stage |
| Group work / GD | `【選考】<Company> GD/グループ選考` | event duration + setup/travel | busy | `GD/グループワーク` |
| Internship | `【インターン】<Company> <Program>` | actual program duration | busy | `インターン参加` |
| Result check | `【確認】<Company> 結果確認` | 15-30 min | transparent | no stage change unless result known |
| MyPage check | `【確認】<Company> MyPage確認` | 15-30 min | transparent | no stage change unless new fact found |
| University assignment | `【課題】<Course> <Task>` | last 60-120 min before deadline or planned work block | transparent for deadline, busy for work block | local note only if exists |
| Class | `【授業】<Course>` | actual class duration | busy | none |
| Work task deadline | `【締切】<Work/Client> <Task>` | last 60-120 min before deadline | transparent | local note only if exists |
| Work meeting | `【仕事】<Meeting>` | actual meeting duration | busy | none |
| Personal appointment | `【予定】<Appointment>` | actual duration | busy | none |
| Focus block | `【作業】<Task>` | requested duration | busy unless temporary/soft | none |
| Soft reminder | `【確認】<Topic>` | 15-30 min | transparent | none |

## Time Rules

- If only a strict deadline is known, make an event ending at the exact deadline.
- If a test starts at a fixed time and requires arrival, use start = arrival time, end = start time + duration + small buffer.
- If a test duration is unknown, use 60 minutes for Web tests and note `要確認`.
- If a result notice says "after deadline", create a result-check task the next day or evening unless the user specifies another time.
- If a university or work deadline needs actual effort, consider creating both a transparent deadline and a busy work block, but do not create the work block unless the user asks or the need is obvious.
- If a physical location is involved, include travel/setup risk in the recommendation even if not encoded in the event.

## Duplicate Search Window

- Deadlines: search from now through 7 days after the deadline, query company name and major keywords.
- Test/interview reservations: search from 2 days before through 2 days after the event.
- Recurring reminders are not used for job-hunt deadlines unless explicitly requested.
- General recurring edits: read the source event or recurrence evidence before writing.
