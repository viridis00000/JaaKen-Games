# 構造化ログスキーマ定義

## 1. 概要

このドキュメントは、Labシステム内で発生するイベントや状態変化を記録するための構造化ログの形式（スキーマ）を定義します。これらのログは、ゲーム状態の再現、デバッグ、分析、そして特に大規模言語モデル（LLM）による状況理解、キャラクター感情分析、リザルト（遺言など）生成の入力として使用されることを目的とします。

## 2. ログ形式

-   **形式**: JSON Lines (JSONL) - 各行が独立したJSONオブジェクトであるテキストファイル形式。
-   **文字コード**: UTF-8

## 3. 基本フィールド (全てのログエントリに共通)

| フィールド名       | 型     | 説明                                                                 | 例                                       | 必須 |
| ---------------- | ------ | -------------------------------------------------------------------- | ---------------------------------------- | ---- |
| `timestamp`      | string | イベント発生日時 (ISO 8601形式, UTC)                                   | `"2024-07-30T10:30:15.123Z"`             | ✅    |
| `logId`          | string | ログエントリの一意なID (UUID推奨)                                        | `"log_b8c4d..."`                         | ✅    |
| `sessionId`      | string | このイベントが発生したセッションのID                                       | `"session_e9f0a..."`                     | ✅    |
| `eventType`      | string | イベントの種類を示す識別子 (詳細は後述)                                  | `"DiceRoll"`                             | ✅    |
| `actorEntityId`  | string | イベントの主体となったエンティティのID (キャラクター、NPC、Mobなど。Nullable) | `"char_a7b3c..."` or `null`              | △    |
| `contextText`    | string | LLMが状況を理解しやすくするための自然言語による補足説明 (任意)             | `"エルドリンが宝箱に罠がないか慎重に調べた。"` |     |
| `importance`     | float  | イベントの重要度 (0.0-1.0)。LLMの記憶/要約生成のヒント (任意、デフォルト0.5) | `0.8`                                    |     |
| `eventData`      | object | イベント固有の詳細データ (JSONオブジェクト)                                | `{ "diceNotation": "1d20+3", ... }`     | ✅    |

## 4. イベントタイプ別 詳細データ (`eventData`) スキーマ

### 4.1. `SessionStart`
-   **説明**: セッション開始
-   **eventData**: `sessionName`, `hostUserId`, `participantUserIds`, `initialMapId`, `gameSystem`

### 4.2. `SessionEnd`
-   **説明**: セッション終了
-   **eventData**: `reason` (Enum: "Completed", "Aborted", "GMClosed", "AllPlayersLeft")

### 4.3. `PlayerJoin` / `PlayerLeave`
-   **説明**: プレイヤーの参加/退出
-   **eventData**: `userId`

### 4.4. `EntityEnter` / `EntityLeave`
-   **説明**: エンティティ（キャラクター、NPC、Mob）の登場/退場
-   **eventData**: `entityId`, `mapId` (Nullable), `position` (Nullable: { `x`, `y`, `z` })

### 4.5. `ChatMessage`
-   **説明**: チャットメッセージ送信
-   **eventData**: `senderEntityId`, `senderUserId`, `messageContent`, `messageType` (Enum: "InCharacter", "OutOfCharacter", "Narration", "System", "ThoughtBubble")

### 4.6. `DiceRoll`
-   **説明**: ダイスロール実行
-   **eventData**: `rollerEntityId`, `rollerUserId`, `diceNotation`, `results` (int[]), `modifier`, `total`, `rollType` (Enum: "Normal", "SkillCheck", "AttackRoll", "DamageRoll", "SavingThrow", "Initiative", "LuckRoll"), `targetValue` (Nullable), `isSuccess` (Nullable), `isCritical` (Nullable)

### 4.7. `EntityStatusChange`
-   **説明**: エンティティのステータス（能力値、HP、状態異常など）変化
-   **eventData**: `targetEntityId`, `statusType` (Enum: "Attribute", "Resource", "SkillLevel", "StatusEffect", "Position", "ExistenceProbability"), `statusName` (例: "HP", "Strength", "Poisoned"), `oldValue`, `newValue`, `changeAmount` (Nullable), `source` (Nullable, 例: "Attack:MOB-Goblin-01", "Spell:HealWounds", "Item:HealthPotion")

### 4.8. `ItemAdded` / `ItemRemoved`
-   **説明**: エンティティがアイテムを入手/喪失
-   **eventData**: `targetEntityId`, `itemId`, `itemDefinitionId`, `quantity`, `sourceOrReason` (Nullable)

### 4.9. `ItemEquipped` / `ItemUnequipped`
-   **説明**: エンティティがアイテムを装備/解除
-   **eventData**: `targetEntityId`, `itemId`, `slot` (Enum: `EquipmentSlotType` from `character_data.md`)

### 4.10. `MapChanged`
-   **説明**: アクティブなマップ変更
-   **eventData**: `newMapId`, `oldMapId` (Nullable), `newMapName`

### 4.11. `EntityMoved`
-   **説明**: マップ上のエンティティ移動
-   **eventData**: `entityId`, `mapId`, `oldPosition` ({ `x`, `y`, `z` }), `newPosition` ({ `x`, `y`, `z` }), `movementType` (Enum: "Walk", "Run", "Teleport", "Forced")

### 4.12. `InteractionChoiceMade`
-   **説明**: エンティティが重要な選択を行った (ダイアログ、イベントなど)
-   **eventData**: `entityId`, `interactionContext` (例: "DialogueWithNPC_Elder"、"ChestTrapChoice"), `promptText`, `optionsPresented` (string[]), `chosenOptionText`, `consequenceSummary` (Nullable)

### 4.13. `GoalUpdated`
-   **説明**: エンティティの目標が設定/更新/達成/失敗
-   **eventData**: `entityId`, `goalId`, `goalDescription`, `goalStatus` (Enum: "Set", "Updated", "Achieved", "Failed", "Abandoned"), `parentGoalId` (Nullable)

### 4.14. `EmotionStateUpdated` (LLM連携用)
-   **説明**: エンティティの感情状態が変化（LLMが推測または明示的に設定）
-   **eventData**: `entityId`, `emotionProfile` (Dictionary<string, float>, 例: `{"Joy": 0.7, "Fear": 0.2, "Anger": 0.1}`), `triggerEventId` (Nullable)

### 4.15. `ArbiterAlertLevelChanged`
-   **説明**: 特定区画またはLab全体のArbiter警戒レベルが変動
-   **eventData**: `targetScope` (Enum: "Sector", "Global"), `targetId` (Nullable, 区画IDなど), `oldLevel`, `newLevel`, `reason` (Nullable)

### 4.16. `RealityStrengthChanged`
-   **説明**: 特定区画またはエンティティの現実強度が変動
-   **eventData**: `targetScope` (Enum: "Sector", "Entity"), `targetId`, `oldStrength`, `newStrength`, `reason` (Nullable)

### 4.17. `GenericGameEvent`
-   **説明**: 上記以外の特定のゲームイベント（`event_data.md` で定義されたイベントの発生など）
-   **eventData**: `gameEventId` (from `event_data.md`), `triggeringEntityId` (Nullable), `involvedEntityIds` (List<string>, Nullable), `customData` (object, イベント定義に応じた詳細)

### 4.18. `SystemMessage`
-   **説明**: システムからの通知、エラー、デバッグ情報など
-   **eventData**: `message`, `severity` (Enum: "Info", "Warning", "Error", "Debug")

## 5. 遺言（リザルト）生成のためのフィールド候補

LLMが「遺言」のようなサマリーテキストを生成する際に特に注目する可能性のあるフィールド：
- `ChatMessage`: `messageContent` (特に感情的な発言や最後の言葉)
- `EntityStatusChange`: `statusName` ("HP"など), `newValue` (0になった場合など), `source` (死因の手がかり)
- `GoalUpdated`: `goalDescription`, `goalStatus` ("Failed" や "Achieved" 直前の目標)
- `EmotionStateUpdated`: `emotionProfile` (死の直前の感情)
- `InteractionChoiceMade`: `chosenOptionText`, `consequenceSummary` (最後の重要な選択と結果)
- `contextText`: 全てのログで、死に至る直前の状況を補足するテキストが重要。
- `importance`: 重要度の高いイベントはより影響が大きい。 