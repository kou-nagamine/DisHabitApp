import Foundation
import SwiftData

// 未受注のクエスト
@Model
class Quest: Identifiable {
    var id: UUID
    var activatedDayOfWeeks: [Int: Bool]
    @Relationship var reward: Reward
    @Relationship var tasks: [StandbyTask]

    init(id: UUID = UUID(), activatedDayOfWeeks: [Int: Bool], reward: Reward, tasks: [StandbyTask]) {
        self.id = id
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
