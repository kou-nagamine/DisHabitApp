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
    
    let id: UUID = UUID()
    let tense: QuestBoardTense
    
    var questSlot: QuestSlot
    var board: DailyQuestBoard
    
    init(modelContext: ModelContext, board: DailyQuestBoard, questSlot: QuestSlot, tense: QuestBoardTense) {
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
    
    func toggleTaskCompleted(acceptedTask: AcceptedTask) async {
        
    }
    
    func discardAcceptedQuest() async {
        
    }
    
    func reportQuestCompletion() async {
        
    }
    
    func redeemTicket() async {
        
    }
}
