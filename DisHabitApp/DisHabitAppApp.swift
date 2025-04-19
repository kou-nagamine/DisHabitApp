import SwiftUI
import SwiftData
import Foundation

@main
struct DisHabitAppApp: App {
//    private let appDataService = AppDataService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Quest.self, StandbyTask.self, Objective.self, DailyQuestBoard.self, QuestSlot.self, AcceptedQuest.self, AcceptedTask.self, Reward.self, RedeemableReward.self])
        }
    }
}
