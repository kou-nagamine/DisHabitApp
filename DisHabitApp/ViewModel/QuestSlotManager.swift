import Foundation
import Observation
import SwiftData

@Observable @MainActor
class QuestSlotManager : Identifiable, Hashable, Equatable {
    static func == (lhs: QuestSlotManager, rhs: QuestSlotManager) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    @ObservationIgnored
    private var modelContext: ModelContext
    
    let id: String
    let tense: QuestBoardTense
    
    var questSlot: QuestSlot
    var board: DailyQuestBoard
    
    init(modelContext: ModelContext, board: DailyQuestBoard, questSlot: QuestSlot, tense: QuestBoardTense) {
        self.id = questSlot.id
        self.modelContext = modelContext
        self.board = board
        self.questSlot = questSlot
        self.tense = tense
    }
    
    func acceptQuest() async {
        do {
            questSlot.acceptedQuest = questSlot.quest.accept()
            try modelContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func toggleTaskCompleted(acceptedTask: AcceptedTask) async {
        do {
            if let acceptedQuest = questSlot.acceptedQuest {
                if let task = acceptedQuest.acceptedTasks.first(where: { $0.id == acceptedTask.id }) {
                    task.toggleValue()
                    try modelContext.save()
                } else {
                    throw QuestSlotError.unexpected("Could not find task")
                }
            } else {
                throw QuestSlotError.notAccepted
            }
        } catch {
            print(error)
        }
    }
    
    func discardAcceptedQuest() async {
        do {
            if let _ = questSlot.acceptedQuest {
                questSlot.acceptedQuest = nil
                try modelContext.save()
            } else {
                throw QuestSlotError.notAccepted
            }
        } catch {
            print(error)
        }
    }
    
    func reportQuestCompletion() async {
        do {
            if let acceptedQuest = questSlot.acceptedQuest {
                acceptedQuest.isCompletionReported = true
                try modelContext.save()
            } else {
                throw QuestSlotError.notAccepted
            }
        } catch {
            print(error)
        }
    }
    
    func redeemTicket() async {
        do {
            if let acceptedQuest = questSlot.acceptedQuest {
                acceptedQuest.redeemReward()
                try modelContext.save()
            } else {
                throw QuestSlotError.notAccepted
            }
        } catch {
            print(error)
        }
    }
    
    func archiveQuest() {
        if questSlot.acceptedQuest != nil {
            return
        }
        
        questSlot.quest.isArchived = true
    }
}

enum QuestSlotError: Error {
    case notAccepted
    case unexpected(String)
}

public enum QuestBoardTense {
    case past
    case today
    case future
}
