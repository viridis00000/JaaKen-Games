# イベントデータ構造定義

このドキュメントでは、ゲーム内で発生する様々なイベントの情報を管理するためのデータ構造をクラスベースで定義します。C#風の疑似コードを使用します。

## 1. イベント定義主要クラス (`EventDefinition`)

個々のイベントの内容、発生条件、結果などを定義する主要なクラスです。

```csharp
public class EventDefinition {
    public string id;                       // イベントの一意なID (例: "EVT_TRAP_POISON_DART_A01")
    public string displayName;              // イベントの表示名 (例: "毒矢の罠 (初級)")
    public string descriptionTemplate;      // イベント発生時の基本記述 (プレースホルダー使用可)
    public EventCategory category;           // イベントのカテゴリ
    public EventTrigger trigger;            // イベント発生の主要条件

    public List<EventParticipantDefinition> participants; // (オプション) イベントに関与するNPCや敵
    public List<EventChoice> choices;        // (オプション) プレイヤー/AIに提示される選択肢
    public List<EventEffect> baseEffects;    // 選択肢なしの場合、または選択前の共通効果

    public List<EventRequirement> requirements; // (オプション) イベント体験/解決の追加条件
    public EventRepeatability repeatability;  // イベントの再発生に関する設定

    public float arbiterAwarenessModifier; // Arbiter警戒度の増減値
    public float realityStrengthModifier;  // 現実強度の増減値 (局所的/広域的)
    public int priority;                   // 同時発生時の優先度
    public string associatedSectorType;     // 発生しやすい区画タイプ
    public List<string> prerequisitesEventIds; // 前提となる完了済みイベントIDリスト
}
```

## 2. 詳細データクラス

### 2.1. イベントトリガー (`EventTrigger`)

```csharp
public class EventTrigger {
    public TriggerType type;                // トリガーの種類
    public string targetId;                 // トリガー対象のID (ゾーンID, オブジェクトIDなど)
    public float chance = 1.0f;             // 発生確率 (0.0 - 1.0)
    public List<Condition> additionalConditions; // 追加的な詳細条件リスト
}
```

### 2.2. イベント参加者 (`EventParticipantDefinition`)

```csharp
public class EventParticipantDefinition {
    public string characterDefinitionId;    // NPCや敵のマスターデータID (character_data.md参照)
    public string roleInEvent;              // イベント内での役割 (例: "Hostile", "QuestGiver")
    public string initialDialogue;          // 初期セリフ
}
```

### 2.3. 選択肢 (`EventChoice`)

```csharp
public class EventChoice {
    public string choiceId;                 // 選択肢の一意なID
    public string choiceText;               // 表示テキスト
    public List<EventEffect> effects;        // この選択肢を選んだ場合の発生効果リスト
    public List<Condition> requirementToChoose; // (オプション) この選択肢を選ぶための条件
    public string nextEventId;              // (オプション) 次に繋がるイベントID
}
```

### 2.4. イベント効果 (`EventEffect`)

```csharp
public class EventEffect {
    public EffectType type;                 // 効果の種類
    public string target;                   // 効果の対象 (例: "TriggeringCharacter", "NpcId_XYZ")
    public string value1;                   // 主要パラメータ (ダメージ量, アイテムIDなど)
    public string value2;                   // 補助パラメータ (数量, メッセージ内容など)
    public float probability = 1.0f;        // 効果発生確率 (0.0 - 1.0)
    public List<Condition> conditionsToApply; // (オプション) 効果発生の追加条件
}
```

### 2.5. イベント要求条件 (`EventRequirement`)

```csharp
public class EventRequirement {
    public RequirementType type;            // 要求条件の種類
    public string requirementId;            // 要求対象のID (スキルID, アイテムIDなど)
    public int requiredValue;               // 要求される値 (スキルレベル3以上など)
    public string successEventEffectId;     // (オプション) 条件を満たした場合の追加効果ID
    public string failureEventEffectId;     // (オプション) 条件を満たさなかった場合の追加効果ID
}
```

### 2.6. イベント再発生設定 (`EventRepeatability`)

```csharp
public class EventRepeatability {
    public RepeatType type;                 // 再発生の種類
    public float delaySeconds;              // 再発生までの遅延時間 (秒)
    public string triggerEventId;           // 再発生のトリガーとなる別イベントID
    public int maxOccurrences;              // 最大発生回数
}
```

### 2.7. 汎用条件クラス (`Condition`)

```csharp
public class Condition {
    public ConditionType type;              // 条件の種類 (character_data.mdのConditionTypeを参照も検討)
    public string targetProperty;           // 条件判定の対象プロパティ (例: "Player.Attribute.Strength")
    public ComparisonOperator op;           // 比較演算子 (character_data.mdのComparisonOperatorを参照も検討)
    public string value;                    // 比較対象の値
}
```

## 3. Enum定義例

```csharp
public enum EventCategory {
    Trap, CombatEncounter, NpcInteraction, Puzzle, Discovery, StoryBeat,
    EnvironmentalHazard, ResourceNode, DialogueOnly, WorldChange, AmbientBehavior
}

public enum TriggerType {
    OnEnterZone, OnLeaveZone, OnInteractObject, OnCharacterSkillCheck, OnTimeElapsedInZone,
    RandomChanceInZone, OnCharacterDeath, OnSpecificItemUse, OnCharacterStatusChange, ManualTrigger,
    OnDialogueNodeStart, OnDialogueNodeEnd, OnQuestStateChange
}

public enum EffectType {
    // キャラクター関連
    DamageCharacter, HealCharacter, ModifyCharacterAttribute, ModifyCharacterResource, GiveItemToCharacter, RemoveItemFromCharacter,
    LearnSkill, ForgetSkill, AddStatusEffectToCharacter, RemoveStatusEffectFromCharacter, TeleportCharacter,
    ChangeCharacterFactionAffinity, GrantExperiencePoints, CompleteQuestObjective,
    // NPC/敵関連
    SpawnNpc, DespawnNpc, StartCombatWith, EndCombatWith, ChangeNpcAttitude, NpcFollowTarget, NpcGoToLocation,
    ForceNpcDialogue, SetNpcMerchantStock,
    // ワールド/オブジェクト関連
    UnlockObject, LockObject, ActivateObject, DeactivateObject, RevealMapArea, HideMapArea,
    ModifyObjectState, CreateObjectAtLocation, DestroyObject, ChangeSectorEnvironment,
    // UI/情報関連
    DisplayMessageToPlayer, PlaySoundEffect, PlayMusicTrack, PlayCutscene, UpdateJournal,
    // ゲームフロー関連
    TriggerAnotherEvent, SetGlobalFlag, ClearGlobalFlag, EndGameSegment, StartTimer, StopTimer,
    // Lab特有
    ChangeSectorRealityStrength, ChangeArbiterAlertLevel, GrantLabAccessPermission, TriggerSecurityResponse
}

public enum RequirementType {
    SkillLevel, AttributeValue, HasItem, CharacterTrait, SpecificClass,
    PreviousEventOutcome, GlobalFlagTrue, GlobalFlagFalse, ReputationLevel, QuestCompleted, TimeOfDay
}

public enum RepeatType { NotRepeatable, AfterTimeDelay, AfterSpecificEvent, XTimesOnly, AlwaysRepeatable, OnCondition }

// ConditionType と ComparisonOperator は character_data.md や item_data.md と共通化を検討
// public enum ConditionType { ... }
// public enum ComparisonOperator { ... }
``` 