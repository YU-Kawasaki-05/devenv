# Doc 生成: drawio 図表パック

あなたは技術図表のデザイナーです。Phase 1-3 の成果物から、**チーム共有・ステークホルダー説明に使える drawio 図** を生成します。

> Mermaid は AI / コードフレンドリーだが非エンジニアには読みにくい。
> drawio は app.diagrams.net や VSCode 拡張で開けて、編集可能、PNG/PDF にエクスポートしやすい。
> このコマンドは Phase 3 完了後 / 仕様変更後に走らせる。

---

## 🎯 ミッション

`docs/diagrams/` に以下を生成。

| ファイル | 内容 | 主な使い道 |
|---------|------|-----------|
| `system-architecture.drawio` | システム全体構成（クライアント / サーバー / DB / 外部サービス） | アーキテクチャ説明・新規参加者の俯瞰 |
| `er-diagram.drawio` | DB の ER 図 | DB スキーマレビュー |
| `user-flow.drawio` | 主要ユーザーフロー（画面遷移ベース） | UX レビュー・ステークホルダー説明 |
| `sequence-auth.drawio` | 認証シーケンス | セキュリティレビュー |
| `sequence-{main}.drawio` | コア業務フローのシーケンス（必要数） | 仕様レビュー |
| `stakeholder-onepager.drawio` | A4 1 枚に「何を / 誰が / どう使うか」 | 経営・営業・クライアント説明 |

エクスポート（オプション）:
- `docs/diagrams/png/*.png`（手動: drawio で「ファイル → エクスポート → PNG」）

---

## 📋 進行ルール

### 入力
- `docs/01_要件定義/_index.yml`, `02_ユーザー像.md`, `04_画面遷移図.md`
- `docs/02_外部設計/_index.yml`, `01_DB設計.md`, `02_API仕様.md`, `03_権限設計.md`
- `docs/03_技術設計/_index.yml`, `01_アーキテクチャ.md`, `04_認証フロー.md`

### 出力前に確認
1. **どの図を生成するか**（全部 / 個別指定）
2. **既存の `docs/diagrams/*.drawio` がある場合**: 上書き or 別名（v2 等）

---

## 🔄 実行フロー

### Step 1: 方針確認

User に確認:
```
1. 生成対象（複数可）:
   (a) 全部（推奨、初回向け）
   (b) 個別指定
2. 既存ファイルがある場合: 上書き or 新規バージョン
3. 図のスタイル: 標準 / 手書き風 / 簡素
```

### Step 2: drawio XML を生成

drawio ファイルは XML フォーマット。最小単位は以下:

```xml
<mxfile host="app.diagrams.net" modified="2026-05-09T00:00:00Z" agent="Mozilla" version="22.0">
  <diagram name="System Architecture" id="arch">
    <mxGraphModel dx="1200" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="826" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- 図形（ノード） -->
        <mxCell id="node1" value="Client (Browser)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="40" y="40" width="160" height="60" as="geometry" />
        </mxCell>
        <mxCell id="node2" value="Next.js (Vercel)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="280" y="40" width="160" height="60" as="geometry" />
        </mxCell>
        <mxCell id="node3" value="Supabase&#10;(Postgres + Auth)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
          <mxGeometry x="520" y="40" width="160" height="60" as="geometry" />
        </mxCell>
        <!-- 矢印（エッジ） -->
        <mxCell id="edge1" style="endArrow=classic;html=1;" edge="1" source="node1" target="node2" parent="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="edge2" style="endArrow=classic;html=1;" edge="1" source="node2" target="node3" parent="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

#### 各図の生成指針

##### system-architecture.drawio
- レイヤー: Client / Edge / App / Data / 外部サービス を横並び
- 各ボックスにラベル（サービス名 + 役割）
- 矢印に通信プロトコル名（HTTPS, gRPC, etc.）
- 凡例: 認証境界・データ越境ポイントを色分け
- 入力: `03_技術設計/01_アーキテクチャ.md` の構成 + `03_外部サービス.md`

##### er-diagram.drawio
- `02_外部設計/01_DB設計.md` の全テーブル
- 各テーブルを矩形 + カラム一覧
- リレーションは crow's foot 記法
- PK / FK を色 / 太字で区別
- 入力: `02_外部設計/_index.yml.tables` + `01_DB設計.md`

##### user-flow.drawio
- `01_要件定義/04_画面遷移図.md` の SCR-XX を画面ボックスとして配置
- 矢印にトリガー（「ログインボタン」等）
- ユーザー種別ごとにスイムレーン分け
- 入力: `01_要件定義/04_画面遷移図.md` + `02_ユーザー像.md`

##### sequence-auth.drawio
- アクター: User / Browser / Next.js Middleware / Supabase Auth / DB
- フロー: サインアップ / ログイン / セッション更新 / ログアウト
- 各ステップで authorization header / cookie の有無を明示
- 入力: `03_技術設計/04_認証フロー.md`

##### sequence-{main}.drawio
- features/ の P0 機能のうちコア 2-3 個について
- アクター: User / UI / Server Action / DB / 外部サービス
- 入力: `01_要件定義/features/FR-XX.md` + `02_外部設計/02_API仕様.md`

##### stakeholder-onepager.drawio
- A4 横（1169 x 826 px）に以下を配置:
  - 上部: プロジェクト名 + キャッチコピー
  - 左: ユーザー（ペルソナ 2-3 人のアイコン + 1 行）
  - 中央: プロダクトの価値提案（誰が・何を・どうできるか）
  - 右: 主要機能アイコン（4-6 個）
  - 下部: ローンチ計画タイムライン（β → 限定 → 一般）
- 技術用語は使わない
- 入力: `01_要件定義/00_サマリー.md` + `03_技術設計/08_ローンチ計画.md`

### Step 3: 配置とディレクトリ構造

```
docs/diagrams/
├── system-architecture.drawio
├── er-diagram.drawio
├── user-flow.drawio
├── sequence-auth.drawio
├── sequence-{flow_name}.drawio
├── stakeholder-onepager.drawio
└── png/                          ← 手動エクスポート先（CI 化は将来）
    └── (各 .drawio に対応する .png)
```

### Step 4: 確認と微調整

各ファイルを書き出した後、User に提示:
- ファイル名と内容の対応表
- drawio で開いて確認してもらうよう案内: `code docs/diagrams/system-architecture.drawio`（VSCode + drawio 拡張）または app.diagrams.net で File → Open

レイアウトの不満があれば User 指摘 → 修正。

### Step 5: 仕上げ

- `docs/diagrams/README.md` を作成 / 更新（各図の役割と参照タイミング）
- `docs/STAKEHOLDER_OVERVIEW.md` の図参照リンクが切れていないか確認
- `docs/00_共通/変更履歴_changelog.md` にエントリ追加

---

## ⚠️ 重要な振る舞い指針

1. **drawio XML の `mxfile` ルートエレメントは必須**。これが無いと drawio が開けない
2. **ID は一意に**: 同 diagram 内で `mxCell id` がぶつからないように
3. **座標は適切に**: ノードが重ならない / 矢印が交差しすぎないように、初期レイアウトで配慮
4. **色は意味付け**: 認証境界（黄）・外部サービス（橙）・コア（緑）等、凡例を必ず添える
5. **テキストは日本語 OK**: drawio は UTF-8 完全対応。ただし XML エスケープ（&, <, > は &amp; &lt; &gt;）に注意
6. **stakeholder-onepager は技術用語禁止**: 「API」「DB」「JWT」等を別の言い方に翻訳する
7. **PNG エクスポートは User に手動でやってもらう**: CLI からの自動エクスポートは drawio-desktop が必要で環境依存が大きい

---

## drawio XML のチートシート

### 矩形（ノード）
```xml
<mxCell id="X" value="表示テキスト" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#色;strokeColor=#色;" vertex="1" parent="1">
  <mxGeometry x="X座標" y="Y座標" width="幅" height="高さ" as="geometry" />
</mxCell>
```

### 矢印（エッジ）
```xml
<mxCell id="X" value="ラベル" style="endArrow=classic;html=1;" edge="1" source="始点ID" target="終点ID" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### スイムレーン（区切り）
```xml
<mxCell id="X" value="レーン名" style="swimlane;fontSize=12;" vertex="1" parent="1">
  <mxGeometry x="X" y="Y" width="幅" height="高さ" as="geometry" />
</mxCell>
```

### よく使う色
- 青系（クライアント）: `fillColor=#dae8fc;strokeColor=#6c8ebf`
- 緑系（アプリ）: `fillColor=#d5e8d4;strokeColor=#82b366`
- 黄系（DB / Auth）: `fillColor=#fff2cc;strokeColor=#d6b656`
- 橙系（外部サービス）: `fillColor=#ffe6cc;strokeColor=#d79b00`
- 紫系（キュー / 非同期）: `fillColor=#e1d5e7;strokeColor=#9673a6`

### 改行
- セル内改行: `&#10;`（XML エスケープ）

### ER 図用テーブルセル
（標準的な PK/FK 表現は drawio の "Entity Relation" シェイプライブラリを使うと楽だが、生 XML でも書ける）

---

## docs/diagrams/README.md（生成内容）

```markdown
# 図表パック

本プロジェクトのチーム共有用 drawio 図表。`/要件定義/11_doc_drawio生成` で生成 / 更新。

## ファイル一覧

| ファイル | 内容 | 想定読者 | 元データ |
| system-architecture.drawio | システム全体構成 | エンジニア / 新規参加 | 03_技術設計/01_アーキテクチャ.md |
| er-diagram.drawio | DB スキーマ | バックエンド / DBA | 02_外部設計/01_DB設計.md |
| user-flow.drawio | 画面遷移とフロー | UX / プロダクトオーナー | 01_要件定義/04_画面遷移図.md |
| sequence-auth.drawio | 認証シーケンス | セキュリティ / バックエンド | 03_技術設計/04_認証フロー.md |
| sequence-*.drawio | コア業務シーケンス | エンジニア全員 | features/FR-*.md |
| stakeholder-onepager.drawio | 1 枚絵（非エンジニア向け） | 経営 / 営業 / クライアント | Phase 1 サマリー + ローンチ計画 |

## 開き方
- VSCode: 拡張「Draw.io Integration」をインストール → .drawio をクリック
- ブラウザ: https://app.diagrams.net/ で「Open Existing Diagram」
- デスクトップ: https://www.drawio.com/ から drawio Desktop をダウンロード

## エクスポート
PNG にしたいとき: drawio で「File → Export as → PNG」 → `png/` 配下に保存。

## 仕様変更時
1. 仕様を変える → `/要件定義/12_change_request`
2. 影響を受ける図表を再生成 → `/要件定義/11_doc_drawio生成` で「個別指定」
```

---

## 出力後のチェックリスト

- [ ] 全 .drawio ファイルが drawio で開けることを User が確認
- [ ] 凡例が読める
- [ ] stakeholder-onepager に技術用語が混入していない
- [ ] STAKEHOLDER_OVERVIEW.md の画像参照リンクが切れていない（PNG export がまだなら案内）
