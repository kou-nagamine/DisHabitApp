import Foundation
import SwiftData

typealias Quest = SchemaValpha011.Quest
typealias StandbyTask = SchemaValpha011.StandbyTask
typealias Objective = SchemaValpha011.Objective
typealias DailyQuestBoard = SchemaValpha011.DailyQuestBoard
typealias QuestSlot = SchemaValpha011.QuestSlot
typealias AcceptedQuest = SchemaValpha011.AcceptedQuest
typealias AcceptedTask = SchemaValpha011.AcceptedTask
typealias Reward = SchemaValpha011.Reward
typealias RedeemableReward = SchemaValpha011.RedeemableReward

enum SchemaValpha011: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(0, 1, 0)
    static var models: [any PersistentModel.Type] {
        [ Quest.self, StandbyTask.self, Objective.self, DailyQuestBoard.self, QuestSlot.self, AcceptedQuest.self, AcceptedTask.self, Reward.self, RedeemableReward.self ]
    }
}

extension SchemaValpha011 {
    @Model
    class Objective: Identifiable {
        var id: UUID
        var text: String

        init(id: UUID = UUID(), text: String) {
            self.id = id
            self.text = text
        }
        
        func copyValues(from source: Objective) {
            self.id = source.id
            self.text = source.text
        }
        
        func deepCopy() -> Objective {
            return Objective(id: self.id, text: self.text)
        }
    }

    @Model
    class StandbyTask: Identifiable {
        var id: UUID
        var text: String
        @Relationship var objective: Objective?
        @Relationship(deleteRule: .nullify, inverse: \Quest.tasks) var quests: [Quest]

        init(id: UUID = UUID(), text: String, objective: Objective? = nil, quests: [Quest] = []) {
            self.id = id
            self.text = text
            self.objective = objective
            self.quests = quests
        }
        
        func copyValues(from source: StandbyTask) {
            self.id = source.id
            self.text = source.text
            self.objective = source.objective
        }
        
        func deepCopy() -> StandbyTask {
            return StandbyTask(id: self.id, text: self.text, objective: self.objective)
        }
    }

    // 受注済みタスク定義
    @Model
    class AcceptedTask: Identifiable {
        var id: UUID = UUID()
        @Relationship var originalTask: StandbyTask
        var isCompleted: Bool = false
        
        init(originalTask: StandbyTask, isCompleted: Bool = false) {
            self.originalTask = originalTask
            self.isCompleted = isCompleted
        }
        
        // 元のTaskのプロパティにアクセスするためのメソッド
        var text: String { originalTask.text }
        var objective: Objective? { originalTask.objective }
        
        // 完了状態を変更した新しいインスタンスを返す
        func markAsCompleted() -> AcceptedTask {
            let updated = AcceptedTask(originalTask: self.originalTask)
            updated.isCompleted = true
            return updated
        }
        
        func toggleValue() {
            isCompleted = !isCompleted
        }
    }
    
    // 未受注のクエスト
    @Model
    class Quest: Identifiable {
        var id: UUID
        var isArchived: Bool
        var activatedDayOfWeeks: [Int: Bool] // 1:Sun - 7:Sat
        @Relationship var reward: Reward
        @Relationship(deleteRule: .nullify) var tasks: [StandbyTask]

        init(id: UUID = UUID(), isArchived: Bool = false, activatedDayOfWeeks: [Int: Bool], reward: Reward, tasks: [StandbyTask]) {
            self.id = id
            self.isArchived = isArchived
            self.activatedDayOfWeeks = activatedDayOfWeeks
            self.reward = reward
            self.tasks = tasks
        }
        
        func copyValues(from source: Quest) {
            self.id = source.id
            self.reward = source.reward
            self.tasks = source.tasks
        }
        
        func deepCopy() -> Quest {
            return Quest(id: self.id, activatedDayOfWeeks: self.activatedDayOfWeeks, reward: self.reward, tasks: self.tasks)
        }
        
        // AcceptedQuestを生成するメソッド
        func accept() -> AcceptedQuest {
            let acceptedTasks = tasks.map { AcceptedTask(originalTask: $0) }
            let accetedReward = RedeemableReward(originalReward: reward)
            
            return AcceptedQuest(
                id: id,
                reward: accetedReward,
                acceptedTasks: acceptedTasks
            )
        }
    }

    // 受注済みクエスト
    @Model
    class AcceptedQuest: Identifiable {
        var id: UUID
        @Relationship var reward: RedeemableReward // 変更: RewardからRedeemableRewardに
        @Relationship var acceptedTasks: [AcceptedTask]
        
        // クエストの完了報告が完了しているかどうかのboolean
        var isCompletionReported: Bool = false
        
        init(id: UUID = UUID(), reward: RedeemableReward, acceptedTasks: [AcceptedTask], isCompletionReported: Bool = false) {
            self.id = id
            self.reward = reward
            self.acceptedTasks = acceptedTasks
            self.isCompletionReported = isCompletionReported
        }
        
        // 全てのタスクが完了しているかどうか
        var isAllTaskCompleted: Bool {
            return acceptedTasks.allSatisfy { $0.isCompleted }
        }

        // タスク完了割合
        var taskCompletionRate: Double {
            let progress = Double(acceptedTasks.filter { $0.isCompleted }.count) / Double(acceptedTasks.count)
            if progress.isNaN {
                return 0
            }
            return progress
        }
        
        // ごほうびを受け取る
        func redeemReward() {
            if isAllTaskCompleted && !reward.isRedeemed {
                reward.markAsRedeemed()
            }
        }
        
        // ごほうびを受け取った新しいインスタンスを返す（イミュータブル版）
        func redeemingReward() -> AcceptedQuest {
            let updated = AcceptedQuest(
                id: self.id,
                reward: self.reward,
                acceptedTasks: self.acceptedTasks,
                isCompletionReported: self.isCompletionReported
            )
            updated.redeemReward()
            return updated
        }
        
        func reportCompletion() -> AcceptedQuest {
            let updated = AcceptedQuest(
                id: self.id,
                reward: self.reward,
                acceptedTasks: self.acceptedTasks,
                isCompletionReported: true
            )
            return updated
        }
    }

    // QuestSlot定義
    @Model
    class QuestSlot: Identifiable {
        @Attribute(.unique) var id: String
        var board: DailyQuestBoard? //reason:https://www.hackingwithswift.com/quick-start/swiftdata/inferred-vs-explicit-relationships
        @Relationship var quest: Quest
        @Relationship var acceptedQuest: AcceptedQuest?
        
        init(board:DailyQuestBoard, quest: Quest, acceptedQuest: AcceptedQuest? = nil) {
            self.id = board.id.description + quest.id.description
            self.board = board
            self.quest = quest
            self.acceptedQuest = acceptedQuest
        }
        
        // クエストを受注するメソッド
        func acceptQuest() {
            self.acceptedQuest = quest.accept()
        }
        
        static func createEmpty() -> QuestSlot? {
            return nil
        }
    }

    // 日次クエストリスト
    @Model
    class DailyQuestBoard: Identifiable {
        var id: UUID
        @Attribute(.unique) var date: Date
        @Relationship(deleteRule: .cascade, inverse: \QuestSlot.board) var questSlots: [QuestSlot] //reason:https://www.hackingwithswift.com/quick-start/swiftdata/inferred-vs-explicit-relationships
        
        init(id: UUID = UUID(), date: Date, questSlots: [QuestSlot]) {
            self.id = id
            self.date = date.startOfDay()
            self.questSlots = questSlots
        }
    }

    // ごほうびメニューアイテム
    @Model
    class Reward: Identifiable {
        var id: UUID
        var text: String
        
        init(id: UUID = UUID(), text: String) {
            self.id = id
            self.text = text
        }
    }

    // 受注済みクエストに付与されるごほうびチケット
    @Model
    class RedeemableReward: Identifiable {
        var id: UUID = UUID()
        @Relationship var originalReward: Reward
        var isRedeemed: Bool = false
        // var grantDate: Date
        var redeemedDate: Date?
        
        init(originalReward: Reward, isRedeemed: Bool = false, redeemedDate: Date? = nil) {
            self.originalReward = originalReward
            self.isRedeemed = isRedeemed
            self.redeemedDate = redeemedDate
        }
        
        // 元のRewardのプロパティにアクセスするためのメソッド
        var text: String { originalReward.text }
        
        // ごほうびを使用済みとしてマークする
        func markAsRedeemed() {
            self.isRedeemed = true
            self.redeemedDate = Date()
        }
        
        // 有効期限を確認（オプション）
    //    func isValid(asOf date: Date = Date()) -> Bool {
    //        // 例: 30日間有効
    //        let validityPeriod: TimeInterval = 30 * 24 * 60 * 60 // 30日間（秒単位）
    //        return !isRedeemed && date < grantDate.addingTimeInterval(validityPeriod)
    //    }
    }

}
