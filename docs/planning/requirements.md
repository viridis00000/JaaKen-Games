# Webゲーム開発要件定義書

## 1. プロジェクト概要

### 開発環境
- フロントエンド: HTML5/CSS3/JavaScript (ES2022+)
- フレームワーク: React.js 18+ または Vanilla JavaScript
- バンドラー: Vite または Webpack 5+
- ターゲットプラットフォーム: Webブラウザ (Chrome/Firefox/Safari/Edge)
- レスポンシブ対応: デスクトップ/タブレット/スマートフォン

### 必要ライブラリ・ツール
- CSS Framework: Tailwind CSS または CSS Modules
- アニメーション: CSS Animations + JavaScript Transitions
- 非同期処理: async/await + Promise
- データ管理: localStorage/IndexedDB
- テスト: Jest + Testing Library
- 型チェック: TypeScript (オプション)

## 2. システム要件

### コアシステム
1. GameManager (JavaScript Class)
   - シングルトンパターン採用
   - ゲームステート管理（Title/MainGame/Event/Battle/GameOver）
   - ページ間データ永続化（sessionStorage/localStorage）

2. UIManager (DOM操作とレスポンシブ対応)
   - コンポーネント管理システム
   - レスポンシブ対応（デスクトップ/タブレット/スマートフォン）
   - ビューポート対応
   - アスペクト比: 9:16基準（CSS Grid/Flexbox活用）

3. CharacterManager (JavaScript Class)
   - キャラクターデータ構造管理（[キャラクターデータ構造](../development/data_structures/character_data.md)参照）
   - ステータス/バフ・デバフ制御
   - 経験値・成長システム（世界設定知識の獲得などを含む）

4.  相互作用システム
   - **セッション内コミュニケーション**: WebSocket または Server-Sent Events
   - **アイテム/情報交換**: プレイヤー間の受け渡し機能（管理区画/スラムで異なるUI/リスクを検討）
   - **協力/対立状態表示**: セッション内での簡易的な関係性表示

### データベースシステム
1. ブラウザストレージ + JSON形式
   ```javascript
   class GameDatabase {
       constructor() {
           this.database = new Map(); // ランタイムデータ用
           this.localStorage = window.localStorage;
           this.indexedDB = window.indexedDB;
       }
       
       // キャラクター・セッションデータの永続化
       // CSVからロードしたマスタデータ（アイテム等）の保持
   }
   ```

2. データ構造
   - キャラクターステータス（[キャラクターデータ構造](../development/data_structures/character_data.md)参照）
     - Affiliation (所属階層/コミュニティ), AccessLevel (アクセス権限), Origin (出自), Knowledge (世界設定知識レベル) などを含む。
   - インベントリ管理（[アイテムデータ構造](../development/data_structures/item_data.md) のエゴアイテム定義含む）
   - アイテムマスターデータ ([アイテムデータ構造](../development/data_structures/item_data.md) 準拠)
   - セッション情報
   - イベントデータ（[イベントデータ構造](../development/data_structures/event_data.md)参照、世界設定反映を考慮）
   - **死亡事象ログデータ** ([技術概要](../development/tech_overview.md#5-デジタルモルグ電子墓地-digital-morgue) および [開発タスク](./development_tasks.md) Phase 5 参照)
     - 基本情報 (時刻, 場所, ID, 所属)
     - 直接死因 (システム判定)
     - 関連状況 (ステータス, 行動ログ, 環境データ)
     - 関係性データ (関連個体IDリスト)
     - 残留思念/最終思考 (LLM連携による生成テキスト、文書システム経由で取得・表示)

### 判定システム
1. 1d100ベース (JavaScript Math.random())
   - 基本判定ロジック
   - 運命数（luck属性）による判定修正
   - スキル・装備補正
   - 判定ロジックにキャラクターの世界設定属性 (`factionId`, `officialTierLevel` など) を考慮する

### イベントシステム
1. イベントキュー (JavaScript Event Loop活用)
   - イベント順序管理
   - 非同期イベント処理 (async/await)
   - イベントチェーン制御
   - イベント内容や分岐に世界設定属性、場所などを反映させる

### 死に様システム
1. 死亡処理
   - 死亡関連データの収集（[開発タスク](./development_tasks.md) Phase 3 参照）
   - 「死亡事象ログ」の基礎データ生成とブラウザストレージへの保存
   - カルマ計算（オプション）
   - 死亡シーン演出 (CSS Animations + JavaScript)
   - 影響伝播処理
   - 死因決定ロジックに世界設定を反映
   - 権限に基づいた「死亡事象ログ」閲覧機能 (**[技術概要](../development/tech_overview.md#5-デジタルモルグ電子墓地-digital-morgue)**機能として実装、LLM生成テキストは文書システム経由)

## 3. 世界観連携要件

- **情報提示**: プレイヤーがゲーム内で世界設定を理解できるよう、Tips、ログ、NPC会話、アイテム説明等で断片的に情報を提供する
- **行動反映**: プレイヤーの行動結果（移動、調査、会話、アイテム使用など）が、キャラクターの世界設定属性や現在の状況（場所、時間など）に応じて変化するようにする
- **テキスト**: ゲーム内テキスト全般に、[世界観概要](../design/world/overview.md)や関連設定で定義された用語や雰囲気を反映させる

## 4. 実装優先度 ([開発タスク](./development_tasks.md) のフェーズ定義と同期)

### Phase 1: コアシステム実装（優先度: 最高）
- プロジェクトセットアップ
- GameManager, UIManager(基本), CharacterManager 実装
- データベース基盤構築 (Key-Valueストア、CSVローダー準備)

### Phase 2: キャラクターと基本インタラクション（優先度: 高）
- キャラクターシステム詳細（1d100判定、ステータス詳細）
- UI基盤開発（MainTextPanelなど主要UI要素）

### Phase 3: コアゲームプレイシステム（優先度: 高）
- 死に様システム（データ収集と基礎ログ生成）
- イベントシステム基本

### Phase 4: データコンテンツ実装（優先度: 中高）
- アイテムデータベース構築（CSV定義と基本データ入力、エゴアイテム概念定義）
- 文書データ基盤（[文書データ構造](../development/data_structures/document_data.md)定義、事前定義文書DB構築）

### Phase 5: 文書システムとLLM連携（優先度: 中）
- 文書生成・管理システム（動的生成、[LLM連携仕様](../development/api_integration/llm_integration.md)による死亡ログテキスト生成）
- 文書ゲームプレイ基盤（アクセス権限など）

### Phase 6: UI詳細実装とインタラクション（優先度: 中）
- 文書関連UI（ビューアー、インベントリなど）
- デジタルモルグUI実装
- アイテム/情報交換UI、協力/対立状態表示UI

### Phase 7: データ永続化（優先度: 中低）
- セーブ・ロード機能実装

### Phase 8: 最適化、テスト、調整（優先度: 低）
- パフォーマンス調整、UI/UX改善、バグ修正、バランス調整

- **注記**: 各フェーズにおいて、世界観連携要件と相互作用システムの実装を継続的に考慮する。

## 5. 技術的要件

### パフォーマンス最適化
- DOM操作の最適化（Virtual DOM または効率的な更新）
- メモリリーク防止（イベントリスナーの適切な削除）
- 画像・アセットの遅延読み込み（Lazy Loading）
- CSS/JavaScriptの最小化とバンドル最適化

### 非同期処理
```javascript
class AssetLoader {
    async loadAsync(key) {
        try {
            // リソース非同期ロード
            const response = await fetch(`/assets/${key}`);
            const data = await response.json();
            // エラーハンドリング
            // キャッシュ管理
            return data;
        } catch (error) {
            console.error('Asset loading failed:', error);
            throw error;
        }
    }
}
```

### セーブデータ
```javascript
class SaveData {
    constructor() {
        this.saveVersion = '1.0.0';
        this.saveTime = new Date().toISOString();
        this.currentState = 'Title';
        this.characters = [];
        this.gameProgress = {};
    }
    
    static createSave() {
        return new SaveData();
    }
    
    toJSON() {
        return JSON.stringify(this);
    }
    
    static fromJSON(jsonString) {
        return Object.assign(new SaveData(), JSON.parse(jsonString));
    }
}
```

## 6. UI要件

### メインテキストシステム (Phase 2 で実装)
```javascript
class TextDisplaySystem {
    constructor(element) {
        this.element = element;
        this.textSpeed = 50; // ms per character
    }
    
    async displayText(text) {
        this.element.textContent = '';
        for (const char of text) {
            this.element.textContent += char;
            await new Promise(resolve => setTimeout(resolve, this.textSpeed));
        }
    }
}
```

### レスポンシブデザイン (Phase 1 から継続的に開発)
- CSS Grid/Flexboxレイアウト
- メディアクエリによる画面サイズ対応
- タッチデバイス対応
- アクセシビリティ対応（ARIA属性、キーボードナビゲーション）

### アイテム/情報交換UI (Phase 6 で実装)
- ドラッグ&ドロップインターフェース
- モーダルダイアログシステム

### 協力/対立状態表示UI (Phase 6 で実装)
- リアルタイム状態更新（WebSocket活用）
- アニメーション付き状態変化表示

### デジタルモルグ (死亡事象ログ閲覧) UI ([技術概要](../development/tech_overview.md#4-ui設計方針)参照) (Phase 6 で実装)
- プレイヤーのアクセス権限に応じたログ情報の表示/非表示制御
- ログデータを整理し、視覚的に分かりやすく表示するUIデザイン

## 7. 品質要件

### パフォーマンス目標
- 初回ロード時間: 3秒以内
- ページ遷移: 1秒以内
- メモリ使用量: 500MB以下（ブラウザタブ単位）
- レスポンス性: 60fps維持

### テスト要件
- ユニットテスト整備（Jest）
- E2Eテスト（Playwright/Cypress）
- パフォーマンステスト（Lighthouse）
- クロスブラウザテスト

## 8. クライアント・サーバーアーキテクチャ

### ブラウザクライアント要件
1. 基本動作
   - ゲームの主要ロジックはブラウザで実行
   - データの永続化はブラウザストレージを基本とする
   - オフライン動作を基本とする（Service Worker活用）

2. ローカルデータ管理
   ```javascript
   class LocalGameManager {
       constructor() {
           this.localDatabase = new GameDatabase();
           this.currentSession = null;
       }
       
       // ローカルデータの保存
       async saveLocalData() {
           const saveData = this.currentSession.toJSON();
           localStorage.setItem('gameSession', saveData);
       }
       
       // ローカルデータの読み込み
       async loadLocalData() {
           const saveData = localStorage.getItem('gameSession');
           if (saveData) {
               this.currentSession = SaveData.fromJSON(saveData);
           }
       }
   }
   ```

### ネットワーク連携要件
1. 必要最小限のネットワーク通信
   - 文書システムのLLM連携（死亡ログ生成など）
   - プレイヤー間の情報交換（管理区画/スラムでの取引など）
   - セッション間のデータ同期（オプション）

2. ネットワーク通信の分離
   ```javascript
   class NetworkManager {
       // LLM連携用
       async requestLLMGeneration(prompt) {
           const response = await fetch('/api/llm/generate', {
               method: 'POST',
               headers: { 'Content-Type': 'application/json' },
               body: JSON.stringify({ prompt })
           });
           return await response.json();
       }
       
       // プレイヤー間通信用
       async sendTradeRequest(targetPlayerId, tradeData) {
           const response = await fetch('/api/trade/request', {
               method: 'POST',
               headers: { 'Content-Type': 'application/json' },
               body: JSON.stringify({ targetPlayerId, tradeData })
           });
           return response.ok;
       }
       
       // セッション同期用（オプション）
       async syncSessionData(sessionId) {
           const response = await fetch(`/api/session/${sessionId}/sync`, {
               method: 'POST',
               headers: { 'Content-Type': 'application/json' },
               body: JSON.stringify(this.currentSession)
           });
           return response.ok;
       }
   }
   ```

3. オフライン対応
   - Service Workerによるオフライン機能
   - ネットワーク未接続時のフォールバック処理
   - ローカルでの一時データ保持
   - 再接続時のデータ同期

4. セキュリティ要件
   - HTTPS通信の強制
   - CSP (Content Security Policy) 設定
   - XSS/CSRF対策
   - データの整合性チェック

### 実装方針
1. フェーズ別実装
   - Phase 1: ブラウザクライアント基盤構築
   - Phase 2: 基本的なゲームロジック実装
   - Phase 5: LLM連携の実装
   - Phase 6: プレイヤー間通信機能の実装
   - Phase 7: オプション機能（セッション同期など）の実装

2. テスト要件
   - オフライン動作テスト
   - ネットワーク通信テスト
   - エラー処理テスト
   - セキュリティテスト 