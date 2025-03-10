//
//  QuestModel.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/03/05.
//

import Foundation

// 未受注のクエスト
struct Quest: Codable, Identifiable {
    var id: String
    var title: String
    var reward: Reward
    var tasks: [Task]
    
    // AcceptedQuestを生成するメソッド
    func accept() -> AcceptedQuest {
        return AcceptedQuest(
            originalQuest: self,
            taskProgress: Dictionary(uniqueKeysWithValues: tasks.map { ($0.id, false) })
        )
    }
}

// 受注済みのクエスト
struct AcceptedQuest: Codable, Identifiable {
    var originalQuest: Quest // 元のクエスト情報を保持
    var taskProgress: [String: Bool] // タスクIDと完了状態のマッピング
    var rewardReceived: Bool = false
    
    var id: String { originalQuest.id }
    var title: String { originalQuest.title }
    var reward: Reward { originalQuest.reward }
    var tasks: [Task] { originalQuest.tasks }
    
    // タスクの完了状態を取得
    func isTaskCompleted(_ taskId: String) -> Bool {
        return taskProgress[taskId] ?? false
    }
    
    // タスクの完了状態を設定するための新しいインスタンスを返す
    func completingTask(_ taskId: String) -> AcceptedQuest {
        var newProgress = taskProgress
        newProgress[taskId] = true
        return AcceptedQuest(
            originalQuest: originalQuest,
            taskProgress: newProgress,
            rewardReceived: rewardReceived
        )
    }
    
    var isQuestCompleted: Bool {
        return taskProgress.allSatisfy { $1 }
    }
}

struct QuestSlot: Codable, Identifiable {
    var id: String { quest.id }
    var quest: Quest
    var acceptedQuest: AcceptedQuest?
    
    // クエストを受注するメソッド
    func acceptQuest() -> QuestSlot {
        return QuestSlot(
            quest: quest,
            acceptedQuest: quest.accept()
        )
    }
}

struct Task: Codable{
    
}
