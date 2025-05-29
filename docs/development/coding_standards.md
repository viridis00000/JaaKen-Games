# コーディング規約と命名規則

このドキュメントでは、プロジェクト内で利用するデータやコードの命名規則、およびコーディングスタイルに関する規約を定義します。
一貫した命名規則とコーディングスタイルは、コードの可読性、保守性、およびチームメンバー間のコラボレーション効率を向上させることを目的とします。

## 1. 基本原則

-   **明確性**: 名前は、その要素の目的や役割を明確に示唆するものであるべきです。
-   **一貫性**: プロジェクト全体で同じ命名規則とスタイルを一貫して使用します。
-   **簡潔性**: 不必要に長い名前は避け、意味が通じる範囲で簡潔にします。
-   **英語**: 全ての命名は英語で行います。

## 2. ファイル名

-   **Markdown / テキストファイル / JSON / CSV**: 小文字スネークケース (`snake_case`) を使用し、拡張子は小文字にします。
    -   例: `character_data.md`, `item_master_data.csv`, `world_settings.json`
-   **C# スクリプトファイル**: PascalCase を使用し、拡張子は `.cs` にします。
    -   例: `CharacterController.cs`, `ItemDatabaseService.cs`, `GameEventManager.cs`

## 3. ディレクトリ名

-   小文字スネークケース (`snake_case`) を使用します。
    -   例: `data_structures/`, `game_systems/`, `user_interface/`, `character_prefabs/`

## 4. C# コーディング規約

### 4.1. クラス名・構造体名・インターフェース名・Enum名

-   PascalCase を使用します。
-   インターフェース名は `I` を接頭辞として付けます（例: `IInventoryManager`, `IDamageable`）。
    -   例: `PlayerStats`, `ItemDefinition`, `CharacterSheetData`, `IInteractable`, `CombatSystem`, `QuestManager`, `WeaponType`, `EnemyState`, `ItemCategory`

### 4.2. プロパティ名・メソッド名・イベント名

-   PascalCase を使用します。
    -   例: `public string DisplayName { get; set; }`, `public int MaxHealth { get; private set; }`, `public void CalculateDamage(int amount)`, `public event Action OnCharacterDeath;`

### 4.3. ローカル変数名・メソッドの引数名・private/protected フィールド名

-   キャメルケース (`camelCase`) を使用します。
-   private/protected フィールド名には、慣習としてアンダースコア `_` を接頭辞として付けることを推奨します（例: `_currentHealth`, `_targetTransform`）。
    -   例: `int currentAttackPower;`, `float itemDropChance;`, `private string _characterName;`, `protected void ProcessEvent(GameEvent gameEvent)`

### 4.4. 定数名 (const, static readonly)

-   全大文字スネークケース (`UPPER_SNAKE_CASE`) を使用します。
    -   例: `public const int MAX_INVENTORY_SLOTS = 50;`, `public static readonly string DEFAULT_SCENE_NAME = "MainHub";`

### 4.5. Enum メンバー名

-   PascalCase を使用します。
    -   例: `public enum ItemType { Weapon, Armor, Consumable }`

### 4.6. 名前空間

-   PascalCase を使用し、プロジェクトの構造や機能に基づいて階層的に定義します。
    -   例: `ProjectName.CoreSystems`, `ProjectName.Gameplay.Characters`, `ProjectName.UI.Menus`

## 5. JSON データフィールド / API キー

-   キャメルケース (`camelCase`) を使用します。
    -   例: `characterId`, `displayName`, `maxHealth`, `baseAttackPower`, `eventTriggerType`, `requiredSkillLevel`

## 6. Key-Value データベースキー (該当する場合)

-   スネークケース (`snake_case`) を使用し、コロン (`:`) で名前空間を区切ることを推奨します。
    -   フォーマット: `<リソースタイプ>:<ID>` または `<リソースタイプ>:<ID>:<サブ要素>`
    -   例: `character_sheet:char001`, `player_session:sessXYZ`, `item_instance:itemABC:durability`, `game_world:current_cycle`

## 7. コメント

-   複雑なロジックや、自明でない設計判断については、簡潔かつ明確なコメントを記述します。
-   公開API（publicメソッドやプロパティ）には、XMLドキュメンテーションコメントを記述することを強く推奨します。

## 8. 書式設定

-   インデント: スペース4つ。
-   括弧: K&Rスタイル (開き括弧は行末、閉じ括弧は次の行)。
-   その他: Visual Studio (またはRider) のデフォルトのC#書式設定に従うことを基本とします。

この規約は、プロジェクトの進行やチームの合意によって更新される可能性があります。 