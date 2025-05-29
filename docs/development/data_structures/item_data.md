# アイテムデータ構造定義

このドキュメントでは、ゲーム内に登場する全てのアイテムの基本情報、効果、特性などを定義するクラスベースのデータ構造を定義します。C#風の疑似コードを使用します。
アイテムの具体的なリストは `items.csv` で管理され、この定義に基づいて解釈されます。

## 1. アイテム定義主要クラス (`ItemDefinition`)

```csharp
public class ItemDefinition {
    public string id;                       // アイテムの一意なID (例: "QO-001", "WEP_KNIFE_STD")
    public string displayName;              // アイテムの表示名
    public ItemCategory category;           // アイテムカテゴリ
    public int rarity = 1;                  // レアリティ (1-10程度)
    public float basePrice = 0;             // 基本価格 (ユニット、取引の基準値)
    public float weight = 0.1f;             // 重量 (kgなど)
    public string description;              // アイテムの詳細な説明文
    public List<string> tags;               // アイテムに付与されるタグ (例: "Military", "Medical", "Experimental")

    public EquipmentSlotType equipableSlot = EquipmentSlotType.None; // 装備可能な場合のスロット
    public WeaponStats weaponStats;         // (オプション) 武器の場合の性能
    public ArmorStats armorStats;           // (オプション) 防具の場合の性能
    public ConsumableEffect consumableEffect; // (オプション) 消費アイテムの場合の効果
    public UsableEffect usableEffect;       // (オプション) 繰り返し使用可能なアイテムの効果 (ツールなど)

    public bool isStackable = true;
    public int maxStackSize = 99;
    public string visualAssetPath;          // アイコンや3Dモデルのアセットパス
    public string soundEffectOnUsePath;     // 使用時の効果音のアセットパス

    // Lab固有の特性
    public float existenceProbability = 1.0f; // 基本的な存在確率 (0.0 - 1.0)
    public int requiredAuthorityLevel = 0;  // 使用/所持に必要なLabの権限レベル
    public float realityInfluenceFactor = 0.0f; // 現実への影響度合い (0.0 - 1.0)
    public QuantumStateProfile quantumStateProfile; // アイテムの量子状態に関する特性

    // エゴ/遺品関連
    public bool isRelicCandidate = false;   // 遺品(エゴアイテム)として生成される可能性があるか
    // public string relicProfileId;        // (オプション) 遺品プロファイルID
}
```

## 2. 詳細データクラスおよびEnum

### 2.1. アイテム効果関連

```csharp
// アイテムが持つ汎用的な効果定義 (特性、消費、使用効果で共通利用を想定)
public class ItemEffect {
    public string effectId;                 // 効果の一意なID (マスターデータで定義された効果を参照)
    public string description;              // 効果の概要説明 (例: "HPを小回復", "一時的に筋力上昇")
    public EffectTargetType targetType = EffectTargetType.Self; // 効果の対象 (使用者自身、ターゲット、範囲など)
    public List<AttributeModification> attributeModifications; // 能力値への直接的な変更
    public List<string> statusEffectIdsToApply; // 付与する状態異常/バフのIDリスト
    public List<string> eventToTrigger;     // 発動するイベントIDリスト (例: 特殊なアニメーション、音響効果、クエストフラグ変更など)
    public float durationSeconds = 0;      // 効果の持続時間 (0なら瞬間的または永続)
    public float chanceToApply = 1.0f;     // 効果発動確率 (0.0 - 1.0)
    public List<Condition> activationConditions; // 発動するための追加条件
}

public enum EffectTargetType { Self, TargetEnemy, TargetAlly, AreaOfEffectSelf, AreaOfEffectTarget, Environment }

// 能力値変更定義
public class AttributeModification {
    public AttributeType attribute;        // 変更対象の能力値 (character_data.mdのAttributeTypeを参照)
    public float modifierValue;            // 変更量 (固定値)
    public ModifierType modifierType = ModifierType.Additive; // 加算か乗算かなど
    public float durationSeconds = 0;      // この変更が持続する時間 (0なら永続)
}
public enum ModifierType { Additive, Multiplicative, Override }

// 消費アイテム効果
public class ConsumableEffect {
    public List<ItemEffect> effectsOnConsume;
    public bool removeItemAfterUse = true;
    public int charges = 1;                 // 使用回数 (1なら単回使用)
}

// 繰り返し使用可能アイテムの効果 (ツールなど)
public class UsableEffect {
    public List<ItemEffect> effectsOnUse;
    public float cooldownSeconds = 0;       // 再使用までのクールダウン
    public int durabilityCostPerUse = 0;  // 使用ごとの耐久度消費 (耐久度システムがある場合)
}
```

### 2.2. 武器・防具性能

```csharp
public class WeaponStats {
    public DamageType primaryDamageType = DamageType.Physical_Kinetic;
    public int baseDamageMin = 1;
    public int baseDamageMax = 1;
    public float criticalHitChance = 0.05f;
    public float criticalHitMultiplier = 1.5f;
    public float attackSpeed = 1.0f;        // 攻撃速度 (秒間攻撃回数など)
    public float range = 1.0f;              // 攻撃範囲 (近接武器なら1.0-2.0m、遠隔ならそれ以上)
    public List<ItemEffect> onHitEffects;   // 命中時に追加で発生する効果
}

public class ArmorStats {
    public int physicalResistance = 0;
    public Dictionary<DamageType, float> elementalResistances; // 属性耐性 (例: Fire: 0.2 は火耐性20%)
    public List<ItemEffect> onEquipEffects; // 装備時に発動するパッシブ効果
    public List<ItemEffect> onDamagedEffects; // 被ダメージ時に確率で発動する効果
}

public enum DamageType { Physical_Kinetic, Physical_Blade, Physical_Pierce, Fire, Cold, Electric, Toxin, Radiation, Quantum, Psionic, Etheric, DataCorruption }
```

### 2.3. 量子状態プロファイル (`QuantumStateProfile`)

```csharp
public class QuantumStateProfile {
    public QuantumStabilityLevel stability = QuantumStabilityLevel.Stable;
    public string dominantPhenomenon;       // 主な量子現象 (例: "観測による収束", "確率的トンネリング")
    public float entanglementPotential = 0.0f; // 他の量子オブジェクトとのエンタングルメントしやすさ
    public string decayMode;                // 劣化/崩壊する場合の様式
}

public enum QuantumStabilityLevel { HyperStable, Stable, Variable, Unstable, CriticallyUnstable }
```

### 2.4. アイテムカテゴリと装備スロット (Enum)

```csharp
public enum ItemCategory {
    Weapon_Melee, Weapon_Ranged, Weapon_Energy, Weapon_Exotic, // 武器
    Armor_Head, Armor_Body, Armor_Hands, Armor_Feet, Armor_Accessory, // 防具
    Shield, // 盾
    Tool_General, Tool_Scientific, Tool_Medical, Tool_Engineering, // 道具
    Consumable_Healing, Consumable_Buff, Consumable_Offensive, Consumable_Misc, // 消費アイテム
    Implant_Cybernetic, Implant_Biotic, Implant_Quantum, // インプラント
    KeyItem,              // 重要アイテム
    CraftingMaterial_Raw, CraftingMaterial_Processed, CraftingMaterial_Exotic, // クラフト素材
    DataLog_Record, DataLog_Schematic, DataLog_Personal, // データログ
    Misc, Currency, QuestItem // その他、通貨、クエスト専用
}

// EquipmentSlotType は character_data.md の定義と共通
// public enum EquipmentSlotType { MainHand, OffHand, Head, Body, Hands, Feet, Accessory1, Accessory2, Implant1, Implant2, Tool }
```

### 2.5. 制限事項関連 (ItemRestrictionDefinition は削除し、ItemEffect内のConditionで表現を検討)

以前の `ItemRestrictionDefinition` は、アイテム効果(`ItemEffect`) 内の `activationConditions` (発動条件) や、アイテム自体の `requiredAuthorityLevel` などで表現することを検討します。より柔軟な条件設定が可能です。

```csharp
// Conditionクラス (event_data.md や skill_data.md と共通化も検討)
public class Condition {
    public ConditionType type;
    public string targetProperty; // (例: "Player.Attribute.Strength", "World.CycleNumber")
    public ComparisonOperator op; // (例: GreaterThan, EqualTo, HasFlag)
    public string value;          // 比較対象の値
}
public enum ConditionType { StatValue, SkillLevel, TraitPresent, ItemInInventory, QuestState, EnvironmentFlag, AuthorityLevel }
public enum ComparisonOperator { EqualTo, NotEqualTo, GreaterThan, LessThan, GreaterThanOrEqualTo, LessThanOrEqualTo, Contains, DoesNotContain, HasFlag, DoesNotHaveFlag }
```

## 3. items.csv との連携

`items.csv` ファイルには、各 `ItemDefinition` のインスタンスデータが格納されます。CSVの各行が1つのアイテム定義に対応し、列が `ItemDefinition` クラスの各プロパティに対応します。
複雑なデータ構造（リストやネストされたクラス）を持つプロパティ（例: `effects`, `weaponStats`）は、CSV内ではJSON文字列として格納するか、あるいは関連テーブルとして別ファイルで管理し、IDで参照する形式などが考えられます。

**例: `items.csv` のヘッダー案**
`id,displayName,category,rarity,basePrice,weight,description,tags,equipableSlot,weaponStats_json,armorStats_json,consumableEffect_json,usableEffect_json,isStackable,maxStackSize,visualAssetPath,soundEffectOnUsePath,existenceProbability,requiredAuthorityLevel,realityInfluenceFactor,quantumStateProfile_json,isRelicCandidate` 