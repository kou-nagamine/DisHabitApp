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
            print("accept")
            questSlot.acceptedQuest = questSlot.quest.accept()
            try modelContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func toggleTaskCompleted(acceptedTask: SchemaV1.AcceptedTask) async {
        
    }
    
    func discardAcceptedQuest() async {
        
    }
    
    func reportQuestCompletion() async {
        
    }
    
    func redeemTicket() async {
        
    }
}
