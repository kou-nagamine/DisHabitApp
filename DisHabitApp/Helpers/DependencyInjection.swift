import Foundation
import Dependencies
import SwiftData

private enum AppDataServiceKey: DependencyKey {
    static let liveValue: any AppDataServiceProtocol = AppDataService()
}

extension DependencyValues {
    var appDataService: any AppDataServiceProtocol {
        get { self[AppDataServiceKey.self] }
        set { self[AppDataServiceKey.self] = newValue }
    }
}

private enum SwiftDataServiceKey: DependencyKey {
    static let liveValue: SwiftDataService = {
        do {
            let container = try ModelContainer(for: Quest.self, StandbyTask.self, Objective.self, DailyQuestBoard.self, QuestSlot.self, AcceptedQuest.self, AcceptedTask.self, Reward.self, RedeemableReward.self)
            return SwiftDataService(modelContainer: container)
        } catch {
            fatalError("Failed to create ModelContainer for SwiftDataService: \(error)")
        }
    }()
}

extension DependencyValues {
    var swiftDataService: SwiftDataService {
        get { self[SwiftDataServiceKey.self] } 
        set { self[SwiftDataServiceKey.self] = newValue }
    }
}
