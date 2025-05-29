# シナリオデータ構造

Labの物語やクエスト、ミッションを構成するためのシナリオデータ構造を定義します。これにより、複雑な物語の分岐、イベントの連鎖、達成目標の管理などを体系的に行うことを目指します。JSON形式での表現を想定していますが、実際のゲームエンジンやツールに合わせてC#クラスなどにマッピングされます。

## 1. シナリオ基本構造 (`ScenarioDefinition`)

```json
{
  "id": "SCN_MainStory_Chapter1_Part1", // シナリオの一意なID
  "title": "失われた技術の断片",          // シナリオのタイトル
  "description": "Arbiterの監視を逃れ、禁断保管庫に眠るとされる古代の技術情報を探す。", // シナリオの概要
  "version": "1.0",
  "author": "NarrativeTeam",
  "tags": ["メインストーリー", "探索", "ステルス", "禁断研究室"],
  "entryPoint": "START_NODE_ID",        // シナリオ開始ノードID
  "startingLocationId": "SECTOR_FORBIDDEN_ARCHIVE_ENTRANCE", // 開始ロケーションID
  "recommendedCharacterLevel": 5,
  "prerequisiteScenarioIds": ["SCN_Tutorial_BasicNavigation"], // 先行して完了が必要なシナリオID
  "globalFlagsRequired": ["FLAG_PlayerHasMetInformantX"], // 開始に必要なグローバルフラグ
  "globalFlagsSetOnCompletion": ["FLAG_Chapter1_Part1_Completed"], // 完了時に設定するグローバルフラグ
  "nodes": [], // シナリオノードのリスト (下記参照)
  "objectives": [], // 目標リスト (下記参照)
  "variables": {}, // シナリオローカル変数 (下記参照)
  "endings": [] // エンディングリスト (下記参照)
}
```

## 2. シナリオノード (`ScenarioNode`)

シナリオの進行単位。イベント、会話、選択、条件分岐などを含みます。

```json
{
  "nodeId": "NODE_001_FindEntrance",
  "nodeType": "Exploration | Dialogue | Combat | Puzzle | Cutscene | Branch",
  "description": "禁断保管庫への秘密の入り口を探す。周囲の監視ドローンに注意。",
  "locationId": "SECTOR_FORBIDDEN_ARCHIVE_PERIMETER",
  "eventDefinitionId": "EVT_DronePatrol_MediumSecurity", // 関連するイベント定義ID (event_data.md参照)
  "dialogueTreeId": null, // (もしあれば) 関連する会話ツリーID
  "requiredConditions": [ // このノードがアクティブになるための条件
    {
      "type": "GlobalFlagCheck",
      "flagName": "FLAG_InformantX_GaveClue",
      "expectedValue": true
    }
  ],
  "choices": [
    {
      "choiceText": "ダクトを通って潜入を試みる (DEXスキルチェック DC15)",
      "skillCheck": {
        "skill": "Dexterity_Stealth",
        "difficultyClass": 15
      },
      "onSuccessNodeId": "NODE_002A_DuctCrawl",
      "onFailureNodeId": "NODE_002B_AlarmTriggered"
    },
    {
      "choiceText": "警備システムのハッキングを試みる (INTスキルチェック DC18)",
      "itemRequired": "ITEM_UniversalDataJack",
      "onSuccessNodeId": "NODE_003A_SystemBypass",
      "onFailureEventId": "EVT_SecurityLockdown_SectorFA"
    }
  ],
  "effectsOnEnter": [ // このノードに入った時点で発生する効果
    { "type": "PlaySound", "value": "SFX_Ambient_TenseDroneHum" }
  ],
  "effectsOnExit": [],
  "linkedObjectiveIds": ["OBJ_Chapter1_FindArchive"] // このノードが関連する目標ID
}
```

## 3. 目標 (`Objective`)

プレイヤーがシナリオ内で達成すべき目標。

```json
{
  "objectiveId": "OBJ_Chapter1_FindArchive",
  "title": "禁断保管庫の入口を発見する",
  "description": "情報屋Xの曖昧なヒントを頼りに、禁断保管庫へと続く隠された入口を見つけ出さなければならない。",
  "objectiveType": "Main | Side | Hidden",
  "status": "Inactive | Active | Completed | Failed",
  "completionConditions": [
    { "type": "ReachNode", "nodeId": "NODE_004_ArchiveDoor" },
    { "type": "ObtainItem", "itemId": "ITEM_ArchiveAccessKey_FragmentA" }
  ],
  "failureConditions": [
    { "type": "GlobalFlagCheck", "flagName": "FLAG_SectorFA_HighAlert", "expectedValue": true }
  ],
  "rewardsOnCompletion": {
    "experiencePoints": 500,
    "itemIdsToAdd": ["ITEM_AncientDataChip_Encrypted"],
    "currencyUnits": 100,
    "globalFlagsToSet": ["FLAG_ArchiveEntranceFound"]
  },
  "subObjectives": [] // (オプション) サブ目標のリスト
}
```

## 4. シナリオローカル変数 (`ScenarioVariables`)

シナリオ内でのみ有効な状態や数値を保存します。

```json
"variables": {
  "alarmLevel": 0, // 0: Normal, 1: Suspicious, 2: Alert, 3: Lockdown
  "informantTrust": 50,
  "collectedClues": []
}
```

## 5. エンディング (`EndingCondition`)

シナリオの終わり方と、それに応じた結果を定義します。

```json
{
  "endingId": "ENDING_Chapter1_StealthSuccess",
  "title": "影の侵入者",
  "description": "あなたは誰にも気づかれることなく禁断保管庫への道を見つけ、古代技術の一端に触れた。Arbiterはまだあなたの存在に気づいていない…今のところは。",
  "type": "Good | Bad | Neutral | Special",
  "priority": 1, // 複数のエンディング条件が満たされた場合の優先度
  "activationConditions": [
    { "type": "ObjectiveStatus", "objectiveId": "OBJ_Chapter1_FindArchive", "expectedStatus": "Completed" },
    { "type": "ScenarioVariableCheck", "variableName": "alarmLevel", "comparison": "LessThanOrEqualTo", "value": 1 }
  ],
  "effectsOnActivation": [
    { "type": "GrantPlayerTrait", "traitId": "TRAIT_ShadowAgent_Rank1" },
    { "type": "UnlockScenario", "scenarioId": "SCN_MainStory_Chapter2_WhispersInTheData" }
  ]
}
```

## 6. 設計思想

-   **モジュール性**: 各シナリオは独立した単位として設計・管理され、他のシナリオやグローバルなゲーム状態と連携できます。
-   **分岐と再結合**: プレイヤーの選択や行動、スキルチェックの結果によって物語が分岐し、また別のポイントで合流するような複雑なナラティブを表現可能です。
-   **状態管理**: グローバルフラグとシナリオローカル変数を用いて、シナリオの進行状況や世界の動的な変化を管理します。
-   **イベント連携**: [イベントデータ構造](./event_data.md)で定義されたイベントをトリガーしたり、イベントの結果によってシナリオが進行したりします。
-   **データ駆動**: シナリオの内容はデータとして定義されるため、ツールによる編集や管理、バランス調整が比較的容易になります。

この構造は、直線的なストーリーだけでなく、探索や謎解きが中心となるミッション、あるいはキャラクター間の関係性が変化するサブストーリーなど、多様なナラティブコンテンツの基盤となることを目指しています。 