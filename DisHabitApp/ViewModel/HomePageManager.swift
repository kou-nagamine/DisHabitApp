import Foundation
import Observation
import SwiftUI
import SwiftData

@Observable
class HomePageManager {
    @ObservationIgnored
    private var modelContext: ModelContext // TODO: env or di
    
    var selectedDate: Date = Date()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var tense: QuestBoardTense {
        let today = Date()
        if self.selectedDate.isSameDayAs(today) {
            return .today
        } else if self.selectedDate < today {
            return .past
        } else {
            return .future
        }
    }

    // ユーザが作成した全曜日のクエスト
    func fetchQuests() -> [Quest] {
        do {
            let fetchDescriptor = FetchDescriptor<Quest>()
            let quests = try modelContext.fetch(fetchDescriptor)
            return quests
        }
        catch {
            return []
        }
    }
    
    func fetchQuestBoard() -> DailyQuestBoard? {
        do {
            let fetchDescriptor = FetchDescriptor<DailyQuestBoard>()
            let boards = try modelContext.fetch(fetchDescriptor)
            let date = self.selectedDate
            return boards.first(where: { $0.date.isSameDayAs(date) })
        }
        catch {
            return nil
        }
    }

    var displayedQuestSlotManagers: [QuestSlotManager] {
        if let board = fetchQuestBoard() {
            return board.questSlots.map { QuestSlotManager(questSlot: $0, questBoardDate: selectedDate, tense: tense) }
        } else {
            switch tense {
            case .today, .future:
                let questSlotManagers = createQuestBoard()
                return questSlotManagers
            case .past:
                return []
            }
        }
    }

    private func createQuestBoard() -> [QuestSlotManager] {
        if tense == .past {
            fatalError("You do not create past quest board with createQuestBoard()")
        }

        // activeQuestsの中から、selectedDateの曜日を持つQuestからQuestSlotを作成
        let date = self.selectedDate
        let questSlots = fetchQuests().filter { $0.activatedDayOfWeeks[date.weekday()] == true }.map { QuestSlot(quest: $0) }
        let questSlotManagers = questSlots.map { QuestSlotManager(questSlot: $0, questBoardDate: selectedDate, tense: tense) }

        let newBoard = DailyQuestBoard(date: date, questSlots: questSlots)

        // 未来の場合はSwiftDataに保存しない
        if tense == .today {
            modelContext.insert(newBoard)
        }
        
        return questSlotManagers
        
    }
}

public enum QuestBoardTense {
    case past
    case today
    case future
}
