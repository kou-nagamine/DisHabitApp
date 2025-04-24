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
    
    var questSlot: SchemaV1.QuestSlot
    var board: SchemaV1.DailyQuestBoard
    
    init(modelContext: ModelContext, board: SchemaV1.DailyQuestBoard, questSlot: SchemaV1.QuestSlot, tense: QuestBoardTense) {
        self.id = questSlot.id
        self.modelContext = modelContext
        self.board = board
        self.questSlot = questSlot
        self.tense = tense
    }
    
    func acceptQuest() async {
        do {
            print("VM: accept quest")
            questSlot.acceptedQuest = questSlot.quest.accept()
            try modelContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func toggleTaskCompleted(acceptedTask: SchemaV1.AcceptedTask) async {
        do {
            print("VM: toggle task completion")
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
            print("VM: give up")
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
            print("VM: report quest completion")
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
            print("VM: report quest completion")
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
}

enum QuestSlotError: Error {
    case notAccepted
    case unexpected(String)
}
