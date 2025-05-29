# キャラクターデータ構造定義

このドキュメントでは、ゲームアプリケーション内でプレイヤーキャラクター、NPC、実験体（Mob）などの情報を管理するための統一的なデータ構造をクラスベースで定義します。C#風の疑似コードを使用します。

## 1. 基本エンティティ定義 (`BaseEntityData`)

全てのキャラクター、NPC、Mobに共通する基本情報を定義する基底クラスです。

```csharp
public abstract class BaseEntityData {
    // I. 基本情報
    public string entityId;                 // システム内で使用する一意のID (例: PLAYER-001, NPC-JACQ-001, MOB-BD-001)
    public string displayName;              // 表示名 (例: 主人公の名前, "ジャッカル", "バイオドロイド")
    public EntityType entityType;           // エンティティの種類 (EntityType.Player, EntityType.FriendlyNpc, EntityType.HostileMobなど)
    public string description;              // 詳細な説明文や背景設定
    public string visualAssetPath;          // (オプション) 3Dモデルやスプライトのアセットパス
    public string factionId;                // 所属する派閥のID

    // II. 能力値
    public AttributesData attributes;

    // III. リソース
    public ResourcesData resources;

    // IV. スキル
    public List<SkillInstance> skills;

    // V. 特性・アビリティ
    public List<TraitInstance> traits;

    // VI. 装備品
    public EquippedItemsData equippedItems;

    // VII. 所持品 (NPC/Mobの場合は主にドロップアイテムリストとして解釈)
    public List<InventoryItemInstance> inventory; 
    public LootTableDefinition lootTable; // Mob用、NPCも一部所持品をドロップする可能性

    // VIII. 状態異常/効果
    public List<StatusEffectInstance> activeStatusEffects;

    // IX. 現在位置情報
    public string currentSectorId;          // 現在いる区画のID
    public BaseLocationData locationInSector; // 区画内での具体的な位置

    // X. 遺伝情報
    public GeneticData geneticInfo;
}
```

## 2. プレイヤーキャラクターシート (`PlayerCharacterSheetData`)

プレイヤーーキャラクター固有の情報を追加します。`BaseEntityData` を継承します。

```csharp
public class PlayerCharacterSheetData : BaseEntityData {
    public string playerId;                 // プレイヤーアカウントに紐づくID
    public string arbiterAdminId;           // Arbiterが管理するプレイヤー識別ID (例: OBSERVER-ALPHA-007)
    public string classDefinitionId;        // クラス/職業定義ID
    public int cyclesInLab;                // Lab内経過サイクル (キャラクターがLabで過ごした、あるいは認識している時間)
    public List<RelationshipData> relationships; // 他のキャラクターとの関係性
    public string personalLog;              // 個人的なログやメモ
    public ArbiterPlayerData arbiterPlayerData; // Arbiterによるプレイヤー固有の記録
}
```

## 3. NPC定義 (`NpcData`)

プレイヤーとインタラクション可能な非敵対/中立キャラクターの定義です。`BaseEntityData` を継承します。

```csharp
public class NpcData : BaseEntityData {
    public string roleDescription;          // NPCの役割 (例: "実験監督", "情報屋", "商人")
    public DialogueTree defaultDialogueTree; // 基本的な会話の選択肢ツリー
    public List<QuestDefinition> questsOffered; // このNPCが提供するクエストのリスト
    public MerchantInventoryDefinition merchantInventory; // (オプション) 商人の場合、販売アイテムリスト
    public List<ServiceDefinition> servicesProvided; // (オプション) 提供するサービス
    public ScheduleDefinition schedule;         // (オプション) NPCの日々の行動スケジュール
    public AIBehaviorProfile aiBehaviorProfile; // (オプション) 戦闘時や特殊状況下での行動パターン
}
```

## 4. 敵対Mob定義 (`HostileMobData`)

プレイヤーに敵対する実験体や機械などの定義です。`BaseEntityData` を継承します。

```csharp
public class HostileMobData : BaseEntityData {
    public DangerLevel dangerLevel = DangerLevel.D; // 危険度 (S, A, B, C, Dなど)
    public int baseAttackPower = 10;
    public int baseDefensePower = 5;
    public List<MobAbilityDefinition> abilities; // 特殊能力や攻撃パターンのリスト
    public AIBehaviorProfile aiBehaviorProfile; // 行動パターンのプロファイル
    public float agroRange = 10.0f;
    public float pursuitRange = 20.0f;
    public List<string> preferredTargetTags;
    public string onDeathEventId;               // (オプション) 死亡時にトリガーされるイベントID
}
```

## 5. 詳細データクラス (共通および派生クラスで使用)

### 5.1. 基本情報関連

```csharp
// EntityType Enum (BaseEntityDataで使用)
public enum EntityType { Player, FriendlyNpc, NeutralNpc, HostileMob, FollowerNpc, InteractiveObject, Projectile }

// ClassDefinition (PlayerCharacterSheetDataで使用、classes.csvからロード想定)
public class ClassDefinition {
    public string id;                           // クラスの一意なID
    public string displayName;                  // 表示名
    public string description;                  // クラスの説明
    public string category;                     // 大分類 (例: "LabStaff", "SlumDweller")
    public List<AttributeModifier> attributeModifiers; // 基本能力値への補正
    public List<string> startingSkillDefinitionIds; // 初期習得スキルIDリスト
    public List<string> classAbilityTraitIds;       // クラス固有アビリティ特性IDリスト
}

// AttributeModifier (ClassDefinitionで使用)
public class AttributeModifier {
    public AttributeType attribute; // 補正対象の能力値
    public int value;               // 補正値
}
```

### 5.2. 能力値 (`AttributesData`)

```csharp
public enum AttributeType { Strength, Dexterity, Intellect, Willpower, Perception, Charisma, Luck } // Perception: 知覚, Charisma: カリスマ, Luck: 運

public class AttributesData {
    public int strength = 1;      // 筋力 (STR)
    public int dexterity = 1;     // 器用さ/機敏さ (DEX)
    public int intellect = 1;     // 知性 (INT)
    public int willpower = 1;      // 意志力 (WIL)
    public int perception = 1;    // 知覚力 (PER) - 罠発見、遠隔命中、隠密発見など
    public int charisma = 1;      // カリスマ (CHA) - NPCとの交渉、リーダーシップなど
    public int luck = 1;          // 運 (LUK) - クリティカル率、レアアイテム発見率など
    // DestinyNumber は Luck で代替、あるいは別途 Trait で表現
}
```

### 5.3. リソース (`ResourcesData`)

```csharp
public class ResourcesData {
    public int currentHealth;
    public int maxHealthBase = 100; // 基本最大HP (能力値や装備で変動前の値)
    public int currentActionPoints; // (オプション) 戦闘時の行動ポイント
    public int maxActionPointsBase = 10; // (オプション)
    public int currentMentalPoints; // (オプション) スキルやアビリティ使用リソース (MP)
    public int maxMentalPointsBase = 50; // (オプション)
    public int currentSanity;       // (オプション) 正気度
    public int maxSanityBase = 100;  // (オプション)
    public int units;                       // Lab内通貨/資源ポイント
    public float cyberneticsRatio = 0.0f;   // サイバネ化比率 (0.0 - 1.0)
    public float existenceProbability = 1.0f; // 存在確率 (0.00-1.00)
}
```

### 5.4. スキル (`SkillInstance`, `SkillDefinition`)

```csharp
public class SkillDefinition { // マスターデータ
    public string id;                   // スキルの一意なID
    public string displayName;          // 表示名
    public AttributeType primaryAttribute; // 関連する主要能力値
    public string description;          // スキルの説明
}

public class SkillInstance {
    public string skillDefinitionId;    // SkillDefinitionのIDを参照
    public int currentLevel;           // 現在のスキルレベル
}
```

### 5.5. 特性・アビリティ (`TraitInstance`, `TraitDefinition`)

```csharp
public enum TraitType { VisibleCharacteristic, HiddenCharacteristic, PassiveAbility, ActiveAbility, GeneticTrait, StatusEffectSource }

public class TraitDefinition { // マスターデータ
    public string id;                   // 特性の一意なID
    public string displayName;          // 表示名
    public string description;          // 特性の説明
    public TraitType type;             // 特性の種類
    // public List<EffectData> effects; // この特性がもたらす具体的な効果 (別途EffectDataクラス定義)
}

public class TraitInstance {
    public string traitDefinitionId;    // TraitDefinitionのIDを参照
    public bool isActive;               // アクティブアビリティの場合、現在使用中かなど
    public float currentStacks;        // (オプション) スタックする特性の場合
}
```

### 5.6. 装備品 (`EquippedItemsData`)

(ItemDefinition は item_data.md で定義想定)
```csharp
public enum EquipmentSlotType { MainHand, OffHand, Head, Body, Hands, Feet, Accessory1, Accessory2, Implant1, Implant2, Tool }

public class EquippedItemsData {
    public Dictionary<EquipmentSlotType, string> equippedItemIds; // スロットタイプと装備アイテムIDのマップ
    public EquippedItemsData() { equippedItemIds = new Dictionary<EquipmentSlotType, string>(); }
}
```

### 5.7. 所持品 (`InventoryItemInstance`, `LootTableDefinition`)

(ItemDefinition は item_data.md で定義想定)
```csharp
public class InventoryItemInstance {
    public string itemDefinitionId;     // ItemDefinitionのIDを参照
    public int quantity;                // 所持数量
    // public Dictionary<string, string> instanceProperties; // (オプション) 個別状態を持つアイテム用 (例: 耐久度、チャージ量)
}

public class LootTableDefinition {
    public List<LootItemEntry> items;
    public int minUnitsDrop = 0;
    public int maxUnitsDrop = 0;
}

public class LootItemEntry {
    public string itemDefinitionId;
    public int minQuantity = 1;
    public int maxQuantity = 1;
    public float dropChance = 1.0f;         // ドロップ確率 (0.0 - 1.0)
}
```

### 5.8. 状態異常/効果 (`StatusEffectInstance`, `StatusEffectDefinition`)

```csharp
public class StatusEffectDefinition { // マスターデータ
    public string id;                   // 効果の一意なID
    public string displayName;          // 表示名
    public string description;          // 効果の説明
    public float defaultDurationSeconds; // 基本持続時間 (0なら永続/解除条件依存)
    public bool isBuff;                 // バフ効果かデバフ効果か
    public bool canStack;               // スタック可能か
    public int maxStacks;               // 最大スタック数
    // public List<EffectData> effects; // この状態がもたらす具体的な効果
}

public class StatusEffectInstance {
    public string statusEffectDefinitionId;
    public float remainingDurationSeconds;
    public int currentStacks;             // 現在のスタック数
    public string sourceEntityId;           // この状態異常の原因となったエンティティID
}
```

### 5.9. 関係性 (`RelationshipData`) (PlayerCharacterSheetDataで使用)

```csharp
public enum RelationshipType { Allied, Friendly, Neutral, Wary, Hostile, Nemesis, Romantic, Family }

public class RelationshipData {
    public string targetCharacterId;    // 対象キャラクターのentityId
    public RelationshipType type;
    public string notes;
    public float value;                 // 関係性の数値 (-100 to 100 など)
    public float trust;                 // 信頼度 (0 to 100)
    public float fear;                  // 恐怖度 (0 to 100)
}
```

### 5.10. Arbiterプレイヤー記録 (`ArbiterPlayerData`) (PlayerCharacterSheetDataで使用)

```csharp
public class ArbiterPlayerData {
    public int officialTierLevel;               // Lab内での公式な階層レベル
    public List<string> accessPrivilegeKeys;   // アクセス可能な区画や情報レベルのキーリスト
    public List<string> surveillanceMarkers;   // Arbiterが特に注目している行動や特性のマーカー
    public string lastEvaluationSummary;       // Arbiterによる最新の評価概要
    public int contributionPoints;              // Labへの貢献度ポイント
    public float threatAssessment;            // Arbiterによる脅威度評価 (0.0 - 1.0)
}
```

### 5.11. 位置情報 (`BaseLocationData` 派生クラス)

```csharp
public abstract class BaseLocationData { }

public class ZoneLocationData : BaseLocationData {
    public string zoneId; // 現在いるゾーンのID
}

public class GridLocationData : BaseLocationData {
    public int x; public int y; public int z; // グリッド座標 (zは階層など)
    public FacingDirection direction; // キャラクターの向き
}
public enum FacingDirection { North, East, South, West, Up, Down, NorthEast, NorthWest, SouthEast, SouthWest }

public class PointLocationData : BaseLocationData {
    public string pointId; // 現在いる重要地点のID
}
```

### 5.12. 遺伝情報 (`GeneticData`)

```csharp
public class GeneticData {
    public string rawDnaSequence; // 基礎要素の配列情報など
    public string genePoolId;       // 遺伝的系統ID
    public List<PhenotypeInstance> expressedPhenotypes; // 発現した遺伝形質
    public string parentAEntityId;
    public string parentBEntityId;
    public int generationNumber;
    public List<string> mutationRecords; // 変異の記録
}

public class PhenotypeInstance {
    public string phenotypeId;          // 形質の一意なID
    public string displayName;          // 表示名
    public string description;          // 形質の説明
    public float expressionValue;      // 形質の発現強度 (0.0 - 1.0)
    // public List<EffectData> effects;
}
```

### 5.13. Mob能力 (`MobAbilityDefinition`)

```csharp
public enum AbilityType { AttackMelee, AttackRanged, BuffSelf, DebuffTarget, HealSelf, HealAlly, SummonMinion, SpecialDefense, AoEAttack, Utility, Movement }

public class MobAbilityDefinition {
    public string abilityId;
    public string abilityName;
    public AbilityType type;
    public float cooldownSeconds;
    public float castTimeSeconds;
    public int resourceCost;
    public List<string> eventEffectIds; // EventEffectのIDリスト (event_data.mdで定義想定)
    public string animationTrigger;
    public string vfxPath;
}
```

### 5.14. AI行動プロファイル (`AIBehaviorProfile`)

```csharp
public enum AIType { AggressiveMelee, AggressiveRanged, DefensiveMelee, DefensiveRanged, SupportCaster, Ambusher, Patroller, Guardian, Scavenger, Social, Merchant }

public class AIBehaviorProfile {
    public AIType primaryBehavior = AIType.AggressiveMelee;
    public float preferredEngagementDistance;
    public bool fleesAtLowHealth = false;
    public float fleeHealthThreshold = 0.2f;
    // public List<AIStatePriority> statePriorities; // より詳細なステートマシンも検討可
}
```

### 5.15. NPC関連 (`DialogueTree`, `QuestDefinition`, `MerchantInventoryDefinition`, `ServiceDefinition`, `ScheduleDefinition`)

(これらの詳細定義は、それぞれの専門ドキュメント (例: `dialogue_system.md`, `quest_system.md`) で行うことを推奨。ここでは概要のみ)
```csharp
public class DialogueTree { public string treeId; public string startingNodeId; /* ... */ }
public class QuestDefinition { public string questId; public string title; /* ... */ }
public class MerchantInventoryDefinition { public List<MerchantItemEntry> itemsForSale; /* ... */ }
public class MerchantItemEntry { public string itemDefinitionId; public int stockQuantity; /* ... */ }
public class ServiceDefinition { public string serviceId; public string serviceName; /* ... */ }
public class ScheduleDefinition { /* NPCの行動スケジュール定義 ... */ }
``` 