# Examples

## University Assignment Deadline

Calendar:
- Title: `【課題】線形代数 レポート提出`
- Start: `2026-06-15T22:00:00+09:00`
- End: `2026-06-15T23:59:00+09:00`
- Transparency: transparent
- Reminders: 48h, 24h, 3h, 1h if close.

Description:

```text
線形代数レポート提出期限。

期限: 2026-06-15(月) 23:59 JST
対応:
- LMSで提出
- 提出後に提出完了画面を確認
```

If the user also needs time to work, propose a separate busy block such as `【作業】線形代数 レポート`.

## Work Meeting

Calendar:
- Title: `【仕事】A社 定例MTG`
- Transparency: opaque
- Preserve attendees, online link, location, and notes on updates.
- If rescheduling a recurring meeting, read recurrence details and confirm scope before writing.

## Strict ES + Web Test Deadline

Payload:

```json
{
  "company": "DTC",
  "event_type": "ES + Web test deadline",
  "deadline": "2026-06-12T12:00:00+09:00",
  "status": ["ES submitted", "Web test remaining"],
  "requirements": ["Web camera PC", "No extension"]
}
```

Calendar:
- Title: `【締切】DTC ES提出・WEBテスト受検`
- Start: `2026-06-12T10:30:00+09:00`
- End: `2026-06-12T12:00:00+09:00`
- Transparency: transparent
- Reminders: 48h, 24h, 3h, 1h

Description:

```text
DTC Summer Job のES提出・WEBテスト受検締切。

期限: 2026-06-12(金) 12:00 JST 厳守
- ES提出: MyPageメニュー「エントリーシート」
- WEBテスト受検: MyPageメニュー「WEBテスト」
- WEBテストはWebカメラ付きPCで受検
- 完了時刻が正午を過ぎると選考対象外
- 理由を問わず期間変更・延長不可

状態:
- ES提出済み
- 残タスク: WEBテスト受検と完了確認
```

## Test Center Reservation

Calendar:
- Title: `【就活】ABeam 構造的把握力検査（テストセンター）`
- Start: arrival time
- End: expected end including small buffer
- Transparency: opaque
- Description includes venue, address, test start, arrival time, cancellation/change deadline.
- Description does not include test center ID or registration numbers.

## Result Check

Calendar:
- Title: `【確認】Ridgelinez 選考結果確認`
- Time: evening after official deadline if no exact result time exists
- Transparency: transparent
- Description: source and expected next step only.
