# 文書データ構造定義

Labシステム内で流通・発見される各種文書のデータ構造と形式について定義します。

## 1. 基本文書構造 (`BaseDocumentData`)

全ての文書タイプに共通する基本構造です。

```csharp
public class BaseDocumentData {
    public string documentId;               // 文書の一意なID (例: LAB-DOC-0001, RES-PROJ7-REPORT-03)
    public DocumentType documentType;       // 文書タイプ (下記のEnum参照)
    public string title;                    // 文書タイトル
    public string content;                  // 文書本文 (プレーンテキスト、Markdown、またはHTML形式を想定)
    public DocumentMetadata metadata;       // メタデータ
    public Dictionary<string, object> formatSpecificData; // 文書タイプ固有の追加データ (下記参照)
}

public class DocumentMetadata {
    public string createdAtCycleTime;       // 作成サイクル.時間 (例: "C1024.1530")
    public int? requiredAccessLevel;      // アクセスに必要な権限レベル (1-10, nullなら制限なし/非公式)
    public string authorOrSource;           // 作成者ID、発行元組織、または入手元情報
    public DocumentStatus status = DocumentStatus.Active; // 文書の現在の状態
    public List<string> tags;               // 関連タグ (検索用)
    public string language = "LabStandard"; // 使用言語 (Lab標準語、その他暗号言語など)
    public float estimatedTruthfulness = 0.5f; // 推定される真実性 (0.0 - 1.0、非公式評価)
    public float dataCorruptionLevel = 0.0f; // データ破損度 (0.0 - 1.0、ジャンク文書などで使用)
}

public enum DocumentType { Official, ResearchReport, MonitoringLog, MortalityLog, PersonalNote, JunkData, TerminalOutput, EncryptedData, ScenarioFragment }
public enum DocumentStatus { Active, Archived, Classified, Redacted, Corrupted, PendingReview, Approved, Rejected }
```

## 2. 文書タイプ別の固有データ構造 (`formatSpecificData` の内容)

### 2.1. 公的文書 (Official)

Arbiterによって生成または承認された公式な通達、マニュアル、プロトコルなど。
機械的で客観的、感情を排した記述が特徴。

```csharp
// formatSpecificData for Official documents
public class OfficialDocData {
    public bool isArbiterCertified = true;
    public OfficialDocCategory category; // (Manual, Protocol, Notice, Directive, PublicRecord)
    public string approverId;           // 承認者ID (Arbiterの特定AIユニットIDなど)
    public string revisionNumber;       // 改訂番号
    public string distributionListId;   // 配布対象リストID
}
public enum OfficialDocCategory { Manual, Protocol, Notice, Directive, PublicRecord, LegalCode, CensusData }
```

### 2.2. 研究報告書 (ResearchReport)

研究者が作成する実験結果、考察、仮説など。専門的だが研究者の解釈が含まれる。

```csharp
// formatSpecificData for ResearchReport
public class ResearchReportData {
    public string projectId;            // 関連プロジェクトID
    public List<string> researcherIds;  // 主任研究者および共同研究者のIDリスト
    public string abstractText;         // 要旨
    public string methodologyDetails;   // 研究方法詳細
    public string resultsSummary;       // 結果概要
    public string discussionAndConclusion; // 考察と結論
    public List<string> citedDocuments; // 参考文献IDリスト
    public ApprovalStatus approvalStatus = ApprovalStatus.Pending;
}
public enum ApprovalStatus { Pending, ApprovedBySupervisor, ApprovedByCommittee, Rejected, RevisionRequested }
```

### 2.3. 監視・モニタリング記録 (MonitoringLog)

Arbiter (Observer AI) が自動生成するセンサーデータや監視カメラ映像の記録。無機質なデータの羅列。

```csharp
// formatSpecificData for MonitoringLog
public class MonitoringLogData {
    public string subjectEntityId;      // 監視対象のエンティティID
    public string monitoringStartCycleTime;
    public string monitoringEndCycleTime;
    public List<LogEntry> logEntries;
}
public class LogEntry {
    public string timestamp;            // 詳細なタイムスタンプ
    public LogEntryType entryType;      // (VitalSign, Behavior, Location, Communication, Anomaly)
    public Dictionary<string, string> dataPayload; // 実際のログデータ (Key-Value形式)
}
public enum LogEntryType { VitalSign, BehaviorPattern, LocationData, CommunicationIntercept, AnomalyDetected, SystemEvent, SecurityAlert }
```

### 2.4. 死亡事象ログ (MortalityLog) - デジタルモルグ

客観的な状況データと、LLMによる主観的推定（最終思考パターン）が混在する特殊な形式。

```csharp
// formatSpecificData for MortalityLog
public class MortalityLogData {
    public string subjectEntityId;      // 死亡対象のエンティティID
    public string deathTimestamp;       // 正確な死亡時刻
    public string deathLocationSector;  // 死亡場所（区画ID）
    public string deathLocationCoordinates; // 死亡場所（区画内座標）
    public string determinedCauseOfDeath; // システムが判定した直接死因
    public string objectiveCircumstances; // 客観的な状況記録（テキストまたは構造化データへの参照）
    public string estimatedFinalThoughts; // LLMにより推定された最終思考（アクセス制限対象）
    public List<string> relatedEntityIds; // 関連した可能性のあるエンティティIDリスト
    public string arbiterInvestigatorId; // (もしあれば) このログを最終確認したArbiterユニットID
}
```

### 2.5. 私的文書 (PersonalNote)

研究者や住民が個人的に作成するメモ、日記、通信ログ（非公式チャネル）。感情的な表現や個人的意見が特徴。

```csharp
// formatSpecificData for PersonalNote
public class PersonalNoteData {
    public string actualAuthorId;       // 真の作成者ID（匿名の場合もある）
    public string intendedRecipientId;  // (もしあれば) 特定の宛先ID
    public string emotionalTone;        // (推定) 文書から読み取れる感情のトーン (例: "Desperate", "Hopeful", "Angry")
    public int encryptionStrength;     // 暗号化の強度 (0なら平文)
    public string discoveryContext;     // 発見された場合の状況や場所
}
```

### 2.6. ジャンク文書 (JunkData)

スラムや放棄区画で発見される、破損・断片化した文書やデータ。隠語や暗号が含まれることも。

```csharp
// formatSpecificData for JunkData
public class JunkDataInfo {
    public string probableOriginSector; // 推定される元々の出所区画
    public float physicalDamageRatio;  // 物理的な破損度 (0.0 - 1.0)
    public float dataReadabilityRatio; // データとしての判読可能性 (0.0 - 1.0)
    public List<string> identifiedKeywords; //辛うじて読み取れたキーワード
    public string potentialValueAssessment; // (スカベンジャーによる)潜在的価値の評価
}
```

### 2.7. 端末応答 (TerminalOutput)

Arbiterシステムや各種端末とのインタラクションにおける表示。効率性重視で最小限の情報のみ。

```csharp
// formatSpecificData for TerminalOutput
public class TerminalOutputData {
    public string terminalId;           // 応答元の端末ID
    public string lastCommandEntered;   // 直前に入力されたコマンド
    public string responseCode;         // システム応答コード (例: "ACCESS_DENIED", "CMD_OK", "ERR_SYNTAX")
    public float processingTimeMs;     // 処理時間 (ミリ秒)
    public string additionalSystemMessage; // システムからの追加メッセージ
}
```

## 3. 文書の視覚的フォーマットと信頼性

-   **表示形式**: ゲーム内では、各文書タイプに応じた特徴的な視覚的スタイル（フォント、レイアウト、ヘッダー情報など）で表示されます。例えば、公的文書は機械的で冷たい印象、私的文書は手書き風や乱雑な表示など。
-   **アクセス制限**: 文書の内容と重要度に応じてアクセスレベルが設定されます。一般的に、公的文書や研究報告書は階層に応じてアクセス可、監視記録や死亡事象ログは高レベル権限が必要、私的文書やジャンク文書は非公式な入手経路が多いです。
-   **真正性と信頼性**: Arbiter認証文書が公式には最高信頼度とされますが、情報操作の可能性も常に存在します。私的記録やジャンク情報にも、稀に重要な真実が含まれていることがあります。プレイヤーは情報の出所や内容を吟味する必要があります。

## 4. `document_formats.md` との関連

`docs.OLD/WorldSettings/document_formats.md` に記述されていた各文書の具体的な表示例（テキストベースのフォーマット案）は、このデータ構造をフロントエンドでレンダリングする際の参考となります。例えば、「【Arbiter承認: Level X】」といったヘッダーは、`BaseDocumentData.documentType` と `DocumentMetadata.requiredAccessLevel` から動的に生成されることになります。 