//import Foundation
//
//// 未受注のクエスト
//class Quest: Identifiable {
//    var id: UUID
//    var title: String
//    var reward: Reward
//    var tasks: [Task]
//
//    init(id: UUID, title: String, reward: Reward, tasks: [Task]) {
//        self.id = id
//        self.title = title
//        self.reward = reward
//        self.tasks = tasks
//    }
//    
//    // AcceptedQuestを生成するメソッド
//    func accept() -> AcceptedQuest {
//        let acceptedTasks = tasks.map { AcceptedTask(originalTask: $0) }
//        let accetedReward = RedeemableReward(originalReward: reward)
//        
//        return AcceptedQuest(
//            id: id,
//            title: title,
//            reward: accetedReward,
//            acceptedTasks: acceptedTasks
//        )
//    }
//}
//
//// 受注済みクエスト
//struct AcceptedQuest: Identifiable {
//    var id: UUID
//    var title: String
//    var reward: RedeemableReward // 変更: RewardからRedeemableRewardに
//    var acceptedTasks: [AcceptedTask]
//    
//    // クエストの完了報告が完了しているかどうかのboolean
//    var isCompletionReported: Bool = false
//    
//    // 全てのタスクが完了しているかどうか
//    var isAllTaskCompleted: Bool {
//        return acceptedTasks.allSatisfy { $0.isCompleted }
//    }
//    
//    // ごほうびを受け取る
//    mutating func redeemReward() {
//        if isAllTaskCompleted && !reward.isRedeemed {
//            reward = reward.markAsRedeemed()
//        }
//    }
//    
//    // ごほうびを受け取った新しいインスタンスを返す（イミュータブル版）
//    func redeemingReward() -> AcceptedQuest {
//        var updated = self
//        updated.redeemReward()
//        return updated
//    }
//    
//    func reportCompletion() -> AcceptedQuest {
//        var updated = self
//        updated.isCompletionReported = true
//        return updated
//    }
//}
//// QuestSlot定義
//struct QuestSlot: Identifiable {
//    var id: UUID
//    var quest: Quest
//    var acceptedQuest: AcceptedQuest?
//    
//    // クエストを受注するメソッド
//    func acceptQuest() -> QuestSlot {
//        return QuestSlot(
//            id: id,
//            quest: quest,
//            acceptedQuest: quest.accept()
//        )
//    }
//    
//    static func acceptQuest() -> QuestSlot? {
//        return nil
//    }
//}
//
//// 日次クエストリスト
//struct DailyQuestBoard: Identifiable {
//    var id: UUID
//    var date: Date
//    var questSlots: [QuestSlot]
//}
//
//// ごほうびメニューアイテム
//struct Reward: Identifiable {
//    var id: UUID
//    var text: String
//}
//
//// 受注済みクエストに付与されるごほうびチケット
//struct RedeemableReward: Identifiable {
//    var originalReward: Reward
//    var isRedeemed: Bool = false
//    // var grantDate: Date
//    var redeemedDate: Date?
//    
//    // 元のRewardのプロパティにアクセスするための転送プロパティ
//    var id: UUID { originalReward.id }
//    var text: String { originalReward.text }
//    
//    // ごほうびを使用済みとしてマークする
//    func markAsRedeemed() -> RedeemableReward {
//        var updated = self
//        updated.isRedeemed = true
//        updated.redeemedDate = Date()
//        return updated
//    }
//    
//    // 有効期限を確認（オプション）
////    func isValid(asOf date: Date = Date()) -> Bool {
////        // 例: 30日間有効
////        let validityPeriod: TimeInterval = 30 * 24 * 60 * 60 // 30日間（秒単位）
////        return !isRedeemed && date < grantDate.addingTimeInterval(validityPeriod)
////    }
//}
