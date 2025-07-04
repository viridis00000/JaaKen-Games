# 遺伝システム

本ゲームにおける遺伝システムは、世界のあらゆる要素に生命的なゆらぎと進化の可能性をもたらすための根幹となるシステムです。

## 1. 基本コンセプトとアナロジー

-   **生きた世界の具現化**: ゲーム世界の舞台そのものが、一つの巨大な生命体、あるいは生きた施設として振る舞います。この生命活動は、バイオームの動的な生成や変化といった形で表現されます。
-   **万物の遺伝**: ワールドマップ、フィールドマップ、キャラクター、アイテム、その他のオブジェクトに至るまで、有機物に存在するほぼ全ての要素が、何らかの「遺伝情報」を保持します。
-   **遺伝情報に基づく形質発現**: 各要素が持つ「遺伝情報」は、生命の設計図に倣い、階層的なアナロジーで捉えることができます。
    -   **DNA（塩基配列）**: フィールドマップを構成する個々のタイル（マス）の特性、資源の種類や配置、ギミックの有無など、最も詳細なレベルの遺伝情報。
    -   **アミノ酸配列**: フィールドマップ全体を構成するタイルの種類やその戦略的な「並び順」。これがフィールドマップ固有の特性を決定づけます。
    -   **タンパク質**: ワールドマップ全体。複数のフィールドマップが組み合わさって形成される高次構造体。ワールドマップの全体的なバイオーム構成、気候、イベント、特殊法則などが「タンパク質」の機能として発現します。
-   **創発的多様性**: 「遺伝情報」の組み合わせや突然変異、要素間の交配によって、予測不能で多様な特性や振る舞いのパターンが創発的に生まれます。

## 2. 遺伝情報の基礎要素

### 2.1. 遺伝子とアレル（対立遺伝子）

-   **遺伝子**: キャラクターやオブジェクトの特定の形質を決定する基本的な情報単位。
-   **アレル**: 一つの遺伝子座に対して存在しうる複数のバリエーション。

### 2.2. アミノ酸的基礎要素 (20種 + 終止シグナル)

フィールドマップを構成する個々のタイル（マス）が持ちうる根源的な特性やポテンシャルのカタログ。これらが配列することでフィールドマップの特性が決まります。

-   **基礎要素の例（一部）**:
    1.  **イデア・アルファ (Ideo-α)**: 純粋エネルギー、活性化、基礎構造の安定性、開始点。
    2.  **モルフォ・ベータ (Morpho-β)**: 柔軟性、適応力、可変性、他要素との結合触媒。
    3.  **リジッド・ガンマ (Rigid-γ)**: 物理的強度、耐久性、反発力、防御構造。
    4.  **グロウス・デルタ (Growth-δ)**: 成長促進、増殖能力、エネルギー貯蔵、再生力。
    5.  **サイファー・イオタ (Cipher-ι)**: 秘匿情報、未知への干渉、希少特性、精神防壁。
    6.  **オリジン・カッパ (Origin-κ)**: 開始シグナル、生命周期の起点、不可逆変化のトリガー。
    (その他、全20種。詳細は `docs.OLD/GeneticSystem/basic_elements.md` 参照)
-   **終止シグナル**: 遺伝情報のある一連の配列（特定の遺伝子領域）の「終わり」を示すマーカー。

## 3. 遺伝子の振る舞い

### 3.1. 遺伝子の連鎖と組換え

-   **連鎖**: 複数の遺伝子がセットで遺伝する現象。
-   **組換え**: 遺伝情報が次世代に受け継がれる際に、染色体の一部が交差・交換され、新たな遺伝子の組み合わせが生じる現象。連鎖していた遺伝子群が分離する可能性も。
-   **独立遺伝**: 連鎖していない遺伝子は、それぞれ独立して子に受け継がれます。

### 3.2. 突然変異

遺伝情報が複製される際や外部要因により、遺伝情報そのものが変化する現象。親世代にはなかった全く新しい形質や、既存の形質の変異が生まれる可能性があります。

-   **発生タイミングと確率**:
    -   世代交代時（複製時）に一定確率でランダム発生。
    -   特定の環境要因（高エネルギー汚染エリア、特殊放射線など）で確率上昇。
    -   特定の「変異誘発物質」との接触・摂取により誘発。
    -   特定のゲーム内イベントやプレイヤーの行動がトリガーとなることも。
-   **突然変異の種類**:
    -   **塩基置換型 (Substitution)**: 一つの基礎要素が別の基礎要素に置き換わる。
    -   **挿入型 (Insertion)**: 基礎要素やタイル列が既存配列の途中に挿入される。
    -   **欠失型 (Deletion)**: 基礎要素やタイル列が既存配列から失われる。
    -   **重複型 (Duplication)**: 特定の基礎要素配列やタイル配列パターンがコピーされ重複して存在する。
    -   **逆位型 (Inversion)**: 特定の基礎要素配列やタイル配列の向きが反転する。
    -   **転座型 (Translocation)**: ある遺伝子コード領域やタイル群が別の位置に移動する。
    -   **開始/終止シグナルの変異**: 遺伝子コード領域の読み取り開始点や終了点が変化し、形質発現に大きな影響を与える。

## 4. 遺伝的形質の発現プロセス

### 4.1. 遺伝子コードの読み取りと解釈

-   **開始シグナル**: 遺伝情報内の意味のある配列の始まりを示すマーカー。
-   **基礎要素の逐次解釈**: 開始シグナル以降、基礎要素が一方向に順次読み取られます。
-   **終止シグナル**: 遺伝子コード領域の終わりを示します。
-   遺伝情報内に複数の遺伝子コード領域が存在しえます。

### 4.2. 「遺伝子エフェクトタグ」の生成

読み取られた遺伝子コード領域内の基礎要素の特定の配列パターン、またはフィールドマップのタイル配列パターンが解析され、一つまたは複数の「遺伝子エフェクトタグ」に変換されます。

-   **例（キャラクター/オブジェクト）**: 「イデア・アルファ x3」 → `EFFECT_TAG_PURE_ENERGY_BOOST`
-   **例（マップ）**: 「リジッド・ガンマタイル集中 + バリア・ニュータイル包囲配列」 → `EFFECT_TAG_MAP_NATURAL_FORTRESS_POTENTIAL`
-   どのようなパターンがどのタグに対応するかは「遺伝子エフェクトライブラリ」で定義されます。

### 4.3. 「遺伝子エフェクトタグ」から具体的な「形質」へ

生成された遺伝子エフェクトタグが、キャラクターのデータ項目やマップの特性に影響を与えます。

-   **影響を受ける形質のカテゴリ例**:
    1.  **基礎能力系形質**: 筋力、HP最大値など。
    2.  **スキル/アビリティ系形質**: スキル習得、パッシブ/アクティブアビリティ。
    3.  **耐性/脆弱性系形質**: 特定属性への耐性や脆弱性、状態異常への抵抗力。
    4.  **感覚/知覚系形質**: 視界範囲、隠密発見能力など。
    5.  **代謝/資源利用系形質**: 食料消費率、アイテム効果量など。
    6.  **外見/形態系形質**: 体格、体表の色や模様、特殊な身体的特徴。
    7.  **精神/行動傾向系形質**: 性格特性、NPCのAIロジック。
    8.  **特殊/異能系形質**: ゲーム独自の特殊能力。
    9.  **マップ特性系形質**: ワールドマップの気候、フィールドマップのバイオーム、資源分布など。
-   効果の重複、前提条件、スケーリングなども考慮されます。

### 4.4. 複数の遺伝子エフェクトの相互作用

-   **相加効果**: 効果が累積。
-   **相殺効果/拮抗効果**: 効果を打ち消し合う。
-   **優性/劣性の関係（オプション）**: 一方の効果が優先的に発現。
-   **エピスタシス（上位効果）**: あるエフェクトが別のエフェクトの発現自体を制御。

### 4.5. 環境要因との相互作用と形質の可塑性（オプション）

遺伝的なポテンシャルが、後天的な要因（経験、環境など）によって発現度合いが変化する可能性。

## 5. ゲームシステムへの応用例

-   キャラクターの成長とカスタマイズ
-   アイテムのプロシージャル生成と強化（エゴアイテムなど）
-   フィールドマップ・ワールドマップの動的生成と進化
-   モンスターやNPCの多様性
-   遺伝子操作関連のクラフトや施設

## 6. 設計上の考慮事項

-   バランス調整（有益/有害な変異、形質強度の制御）
-   プレイヤーへの情報提示方法
-   処理負荷と最適化

## 7. Labにおけるバイオテクノロジーと遺伝子操作

Labでは、バイオテクノロジーが高度に発達しており、遺伝子編集技術（CRISPR-Casシリーズの遥か先）や合成生物学（人工DNA、人工細胞）が基盤となっています。

-   **被験体の設計と調整**: 実験目的に合わせ、身体能力、感覚、知性、寿命、環境耐性などを精密に調整・強化。特殊能力の付与や、全く新しい形態の生命体の創造も行われます。
-   **精神工学 (Psycho-Engineering)**: 記憶の操作、感情の制御、意識の介入など、精神や意識に直接介入する技術も遺伝情報と関連して研究・応用されている可能性があります。
-   **限界と代償**: 生体改造には副作用（代謝異常、組織不安定性、精神的影響）が伴い、遺伝子操作にも世代間不安定性やシステム複雑性といった限界が存在します。失敗した実験や制御不能になった創造物は厳重に管理・隔離されます。 