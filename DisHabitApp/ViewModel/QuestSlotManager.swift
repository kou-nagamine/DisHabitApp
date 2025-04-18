import Foundation
import Observation
import SwiftData

@Observable
class QuestSlotManager : Identifiable {
//    @ObservationIgnored
//    private var modelContext: ModelContext // TODO: env or di

    let id: UUID = UUID()
    let questSlot: QuestSlot
    let questBoardDate: Date
    let tense: QuestBoardTense

    init(questSlot: QuestSlot, questBoardDate: Date, tense: QuestBoardTense) {
        self.questSlot = questSlot
        self.questBoardDate = questBoardDate
        self.tense = tense
    }
}
