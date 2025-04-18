import Foundation
import Combine
import SwiftData
import Dependencies

protocol AppDataServiceProtocol {
    var activeQuestsPubisher: AnyPublisher<[Quest], Never> { get }
    var tasksPubisher: AnyPublisher<[StandbyTask], Never> { get }
    var objectivesPubisher: AnyPublisher<[Objective], Never> { get }
    var historyQuestBoardsPubisher: AnyPublisher<[DailyQuestBoard], Never> { get }
    var selectedQuestBoardPublisher: AnyPublisher<DailyQuestBoard, Never> { get }

    // タスクをこなす系
    func acceptQuest(questSlotId: UUID) async
    func toggleTaskCompletion(questSlotId: UUID, taskId: UUID) async
    func reportQuestCompletion(questSlotId: UUID) async
    func redeemTicket(questSlotId: UUID) async
    func discardAcceptedQuest(questSlotId: UUID) async
    

    // クエストの作成・編集関連
    func queryActiveQuests() async
    func createQuest(newQuest: Quest) async
    func editQuest(questId: UUID, newQuest: Quest) async
    func deleteQuest(questId: UUID) async

    // タスクの作成・編集関連
    func queryTasks() async
    func createTask(newTask: StandbyTask) async
    func editTask(taskId: UUID, newTask: StandbyTask) async
    func deleteTask(taskId: UUID) async

    // 目標の作成・編集関連
    func queryObjectives() async
    func createObjective(newObjective: Objective) async
    func editObjective(objectiveId: UUID, newObjective: Objective) async
    func deleteObjective(objectiveId: UUID) async

    // 履歴関係
    func queryHistoryQuestBoards() async
    func createHistoryQuestBoard(newHistoryQuestBoard: DailyQuestBoard) async
    
    func debug_ResetAcceptedQuests() async
    func debug_ReloadTodayQuestBoard() async
}

class AppDataService: AppDataServiceProtocol {
    @Dependency(\.swiftDataService) var swiftDataService

    private var cancellables = Set<AnyCancellable>()
    
    private let activeQuestsSubject = CurrentValueSubject<[Quest], Never>([])
    private let tasksSubject = CurrentValueSubject<[StandbyTask], Never>([])
    private let objectivesSubject = CurrentValueSubject<[Objective], Never>([])
    private let historyQuestBoardsSubject = CurrentValueSubject<[DailyQuestBoard], Never>([])
    private let todayQuestBoardSubject = CurrentValueSubject<DailyQuestBoard?, Never>(nil)
    private let selectedQuestBoardSubject = CurrentValueSubject<DailyQuestBoard, Never>(DailyQuestBoard(id: UUID(), date: Date(timeIntervalSince1970: TimeInterval()), questSlots: []))

    // ==== Public publishers of lists ====
    var activeQuestsPubisher: AnyPublisher<[Quest], Never> { activeQuestsSubject.eraseToAnyPublisher() }
    var tasksPubisher: AnyPublisher<[StandbyTask], Never> { tasksSubject.eraseToAnyPublisher() }
    var objectivesPubisher: AnyPublisher<[Objective], Never> { objectivesSubject.eraseToAnyPublisher() }
    var historyQuestBoardsPubisher: AnyPublisher<[DailyQuestBoard], Never> { historyQuestBoardsSubject.eraseToAnyPublisher() }
    var selectedQuestBoardPublisher: AnyPublisher<DailyQuestBoard, Never> { selectedQuestBoardSubject.eraseToAnyPublisher() }

    init () {
        // ==== 依存関係にあるデータの変更通知のWaterfallさせる ====
        // objectives -> tasks -> activeQuests -> selectedQuestBoard = todaySubjectBoard
        
        // objectives -> tasks
        objectivesPubisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] objectives in
                guard let self = self else { return }
                self.activeQuestsSubject.send(self.activeQuestsSubject.value)
//                print("objectives->tasks")
            }
            .store(in: &cancellables)

        // tasks -> activeQuests
        tasksPubisher
            .receive(on: RunLoop.main)
            .sink { [weak self] tasks in
                guard let self = self else { return }
                self.activeQuestsSubject.send(self.activeQuestsSubject.value)
//                print("tasks->activeQuests")
            }
            .store(in: &cancellables)
        
        // activeQuests -> selectedQuestBoard
        activeQuestsPubisher
            .receive(on: RunLoop.main)
            .sink { [weak self] quests in
                guard let self = self else { return }
                self.selectedQuestBoardSubject.send(self.selectedQuestBoardSubject.value)
                // TODO: todayQuestBoardでquestSlotを作成する処理
//                print("quests->selectedQuestBoard")
            }
            .store(in: &cancellables)

        // todayQuestBoard -> selectedQuestBoard
        todayQuestBoardSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] questBoard in
                guard let self = self else { return }
                if let todayQuestBoard = questBoard {
                    if self.selectedQuestBoardSubject.value.date == todayQuestBoard.date {
                        self.selectedQuestBoardSubject.send(todayQuestBoard)
                    }
                }
            }
            .store(in: &cancellables)
        
        _Concurrency.Task {
            await loadData()
        }
    }

    private func loadData() async {
        do {
            let objectives = try await swiftDataService.fetchObjectives()
            if objectives == [] { // MARK: only for TestFlight
                await createInitialDataForTestFlight()
            } else {
                objectivesSubject.send(objectives)
                let tasks = try await swiftDataService.fetchTasks()
                tasksSubject.send(tasks)
                let quests = try await swiftDataService.fetchQuests()
                activeQuestsSubject.send(quests)
            }
            let historyBoards = try await swiftDataService.fetchHistoryQuestBoards()
            historyQuestBoardsSubject.send(historyBoards)
            
            await queryTodayQuestBoard(setSelectedQuestBoardToToday: true)
            print("Loaded local app data.")
        } catch {
            print("Failed to load initial data: \(error)")
        }
    }
    
    private func createInitialDataForTestFlight() async {
        let objective1 = Objective(id: UUID(), text: "健康的な生活を送る")
        let objective2 = Objective(id: UUID(), text: "勉強習慣を身につける")
        let objective3 = Objective(id: UUID(), text: "運動を習慣化する")
        
        let task1 = StandbyTask(id: UUID(), text: "朝7時に起床する", objective: objective1)
        let task2 = StandbyTask(id: UUID(), text: "朝食を食べる", objective: objective1)
        let task3 = StandbyTask(id: UUID(), text: "1時間勉強する", objective: objective2)
        let task4 = StandbyTask(id: UUID(), text: "30分ジョギングする", objective: objective3)
        let task5 = StandbyTask(id: UUID(), text: "ストレッチをする", objective: objective3)
        
        let reward1 = Reward(id: UUID(), text: "好きなお菓子を1つ買う")
        let reward2 = Reward(id: UUID(), text: "映画を見る")
        
        let quest1 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward1, tasks: [task1, task2, task5])
        let quest2 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward2, tasks: [task4, task5])
        
        await createObjective(newObjective: objective1)
        await createObjective(newObjective: objective2)
        await createObjective(newObjective: objective3)
        await createTask(newTask: task1)
        await createTask(newTask: task2)
        await createTask(newTask: task3)
        await createTask(newTask: task4)
        await createTask(newTask: task5)
        await createQuest(newQuest: quest1)
        await createQuest(newQuest: quest2)
        
        print ("Created initial sample data.")
    }

    // ==== Publishers for single items for each list ====
    func activeQuestPublisher(for id: UUID) ->  AnyPublisher<Quest?, Never> {
        activeQuestsSubject
            .map { quests in
                quests.first { $0.id == id }
            }
            .eraseToAnyPublisher()
    }
    func taskPublisher(for id: UUID) ->  AnyPublisher<StandbyTask?, Never> {
        tasksSubject
            .map { tasks in
                tasks.first { $0.id == id }
            }
            .eraseToAnyPublisher()
    }
    func objectivePublisher(for id: UUID) ->  AnyPublisher<Objective?, Never> {
        objectivesSubject
            .map { objectives in
                objectives.first { $0.id == id }
            }
            .eraseToAnyPublisher()
    }
    func historyQuestBoardPublisher(for id: UUID) ->  AnyPublisher<DailyQuestBoard?, Never> {
        historyQuestBoardsSubject
            .map { historyQuestBoards in
                historyQuestBoards.first { $0.id == id }
            }
            .eraseToAnyPublisher()
    }
    func questSlotPublisher(for id: UUID) ->  AnyPublisher<QuestSlot?, Never> {
        selectedQuestBoardSubject
            .map { questBoard in
                questBoard.questSlots.first { $0.id == id }
            }
            .eraseToAnyPublisher()
    }

    // MARK: ==== Public methods ====
    func acceptQuest(questSlotId: UUID) async {
        await updateTodayQuestBoard(questSlotId) { questSlot in
            questSlot.acceptQuest()
        }
    }

    func toggleTaskCompletion(questSlotId: UUID, taskId: UUID) async {
        await updateTodayQuestBoard(questSlotId) { questSlot in
            guard let acceptedQuest = questSlot.acceptedQuest else { return }
            if let index = acceptedQuest.acceptedTasks.firstIndex(where: { $0.id == taskId }) {
                acceptedQuest.acceptedTasks[index].toggleValue()
            }
        }
    }

    func reportQuestCompletion(questSlotId: UUID) async {
        await updateTodayQuestBoard(questSlotId) { questSlot in
            guard let acceptedQuest = questSlot.acceptedQuest else { return }

            if !acceptedQuest.isAllTaskCompleted {
                return
            }
            
            acceptedQuest.isCompletionReported = true
        }
    }

    func redeemTicket(questSlotId: UUID) async {
        await updateTodayQuestBoard(questSlotId) { questSlot in
            guard let acceptedQuest = questSlot.acceptedQuest else { return }

            acceptedQuest.redeemReward()
        }
    }

    func discardAcceptedQuest(questSlotId: UUID) async {
        await updateTodayQuestBoard(questSlotId) { questSlot in
            questSlot.acceptedQuest = nil
        }
    }

    // MARK: - クエストの作成・編集関連
    func queryActiveQuests() async {
        do {
            let quests = try await swiftDataService.fetchQuests()
            activeQuestsSubject.send(quests)
        } catch {
            print("Failed to query active quests: \(error)")
        }
    }
    
    func createQuest(newQuest: Quest) async {
        do {
            try await swiftDataService.createQuest(newQuest: newQuest)
            await queryActiveQuests()
        } catch {
            print("Failed to create quest: \(error)")
        }
    }
    
    func editQuest(questId: UUID, newQuest: Quest) async {
        do {
            try await swiftDataService.editQuest(questId: questId, newQuest: newQuest)
            await queryActiveQuests()
        } catch {
            print("Failed to edit quest: \(error)")
        }
    }
    
    func deleteQuest(questId: UUID) async {
        do {
            try await swiftDataService.deleteQuest(questId: questId)
            await queryActiveQuests()
        } catch {
            print("Failed to delete quest: \(error)")
        }
    }

    // MARK: - タスクの作成・編集関連
    func queryTasks() async {
        do {
            let tasks = try await swiftDataService.fetchTasks()
            tasksSubject.send(tasks)
        } catch {
            print("Failed to query tasks: \(error)")
        }
    }
    
    func createTask(newTask: StandbyTask) async {
        do {
            try await swiftDataService.createTask(newTask: newTask)
            await queryTasks()
        } catch {
            print("Failed to create task: \(error)")
        }
    }
    
    func editTask(taskId: UUID, newTask: StandbyTask) async {
        do {
            try await swiftDataService.editTask(taskId: taskId, newTask: newTask)
            await queryTasks()
        } catch {
            print("Failed to edit task: \(error)")
        }
    }
    
    func deleteTask(taskId: UUID) async {
        do {
            try await swiftDataService.deleteTask(taskId: taskId)
            await queryTasks()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }

    // MARK: - 目標の作成・編集関連
    func queryObjectives() async {
        do {
            let objectives = try await swiftDataService.fetchObjectives()
            objectivesSubject.send(objectives)
        } catch {
            print("Failed to query objectives: \(error)")
        }
    }
    
    func createObjective(newObjective: Objective) async {
        do {
            try await swiftDataService.createObjective(newObjective: newObjective)
            await queryObjectives()
        } catch {
            print("Failed to create objective: \(error)")
        }
    }
    
    func editObjective(objectiveId: UUID, newObjective: Objective) async {
        do {
            try await swiftDataService.editObjective(objectiveId: objectiveId, newObjective: newObjective)
            await queryObjectives()
        } catch {
            print("Failed to edit objective: \(error)")
        }
    }
    
    func deleteObjective(objectiveId: UUID) async {
        do {
            try await swiftDataService.deleteObjective(objectiveId: objectiveId)
            await queryObjectives()
        } catch {
            print("Failed to delete objective: \(error)")
        }
    }

    // MARK: - 履歴関係
    func queryHistoryQuestBoards() async {
        do {
            let historyBoards = try await swiftDataService.fetchHistoryQuestBoards()
            historyQuestBoardsSubject.send(historyBoards)
        } catch {
            print("Failed to query history quest boards: \(error)")
        }
    }
    
    func createHistoryQuestBoard(newHistoryQuestBoard: DailyQuestBoard) async {
        do {
            try await swiftDataService.createQuestBoard(newQuestBoard: newHistoryQuestBoard)
            await queryHistoryQuestBoards()
            if Calendar.current.isDateInToday(newHistoryQuestBoard.date) {
                todayQuestBoardSubject.send(newHistoryQuestBoard)
            }
        } catch {
            print("Failed to create history quest board: \(error)")
        }
    }
    
    func queryTodayQuestBoard(setSelectedQuestBoardToToday: Bool = false) async {
        do {
            let calendar = Calendar.current
            let todayStart = calendar.startOfDay(for: Date())
            
            if let todayBoard = try await swiftDataService.fetchDailyQuestBoard(for: todayStart) {
                self.todayQuestBoardSubject.send(todayBoard)
                if setSelectedQuestBoardToToday {
                    self.selectedQuestBoardSubject.send(todayBoard)
                }
            } else {
                let newTodayBoard = createNewDailyQuestBoard(for: todayStart)
                try await swiftDataService.createQuestBoard(newQuestBoard: newTodayBoard) // MARK: これダメだった時はアプリ再起動しかない？
                self.todayQuestBoardSubject.send(newTodayBoard)
                if setSelectedQuestBoardToToday {
                    self.selectedQuestBoardSubject.send(newTodayBoard)
                }
            }
            
        } catch {
            print("Failed to query today's quest board: \(error)")
        }
    }
    
    
    func debug_ResetAcceptedQuests() async {
        guard let todayBoard = todayQuestBoardSubject.value else { return }
        for slot in todayBoard.questSlots {
            await updateTodayQuestBoard(slot.id) { questSlot in
                questSlot.acceptedQuest = nil
            }
        }
    }
    
    func debug_ReloadTodayQuestBoard() async {
        for qs in self.todayQuestBoardSubject.value?.questSlots ?? [] {
            print(qs.quest.reward.text)
        }
        do {
            try await swiftDataService.debug_deleteTodayQuestBoard()
            await queryTodayQuestBoard(setSelectedQuestBoardToToday: true)
        } catch {
            print("error occured on debug_ReloadTodayQuestBoard()")
        }
    }

    // ==== Private helpers ====
    private func updateTodayQuestBoard(_ questSlotId: UUID, _ updateAction: (QuestSlot) -> Void) async {
        guard let todayBoard = todayQuestBoardSubject.value else { 
            print("Error: Today's quest board is not loaded.")
            return
        }
        
        guard let index = todayBoard.questSlots.firstIndex(where: { $0.id == questSlotId }) else {
            print("Error: Quest slot with id \(questSlotId) not found in today's board.")
            return
        }

        let slotToUpdate = todayBoard.questSlots[index]
        updateAction(slotToUpdate)

        do {
            try await swiftDataService.updateDailyQuestBoard(todayBoard)
            todayQuestBoardSubject.send(todayBoard)
        } catch {
            print("Failed to update today quest board: \(error)")
        }
    }
    
    // 新しいDailyQuestBoardを作成するヘルパー関数
    private func createNewDailyQuestBoard(for date: Date) -> DailyQuestBoard {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) // 1:日曜日, 2:月曜日, ..., 7:土曜日

        // 現在アクティブなクエストを取得（この日の曜日に有効なもの）
        let activeQuests = activeQuestsSubject.value.filter { quest in
            quest.activatedDayOfWeeks[weekday] ?? false
        }

        // アクティブなクエストからQuestSlotを作成
        let questSlots = activeQuests.map { quest in
            QuestSlot(quest: quest, acceptedQuest: nil) // 最初は未受注状態
        }

        return DailyQuestBoard(date: date, questSlots: questSlots)
    }
}
