import SwiftUI
import SwiftData
import Foundation

@main
struct DisHabitAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Objective.self, Task.self, AcceptedTask.self, Quest.self, AcceptedQuest.self, QuestSlot.self, DailyQuestBoard.self, Reward.self, RedeemableReward.self], isUndoEnabled: true)
    }
}
