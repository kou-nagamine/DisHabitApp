import Foundation
import Combine
import SwiftData


protocol AppDataServiceProtocol {
    var activeQuestsPubisher: AnyPublisher<[Quest], Never> { get }
    var tasksPubisher: AnyPublisher<[Task], Never> { get }
    var objectivesPubisher: AnyPublisher<[Objective], Never> { get }
    var historyQuestBoardsPubisher: AnyPublisher<[DailyQuestBoard], Never> { get }
    var selectedQuestBoardPublisher: AnyPublisher<DailyQuestBoard, Never> { get }

    // タスクをこなす系
    func acceptQuest(questSlotId: UUID)
    func toggleTaskCompletion(questSlotId: UUID, taskId: UUID)
    func reportQuestCompletion(questSlotId: UUID)
    func redeemTicket(questSlotId: UUID)
    func discardAcceptedQuest(questSlotId: UUID)

    // クエストの作成・編集関連
    func queryActiveQuests()
    func createQuest(newQuest: Quest)
    func editQuest(questId: UUID, newQuest: Quest)
    func deleteQuest(questId: UUID)

    // タスクの作成・編集関連
    func queryTasks()
    func createTask(newTask: Task)
    func editTask(taskId: UUID, newTask: Task)
    func deleteTask(taskId: UUID)

    // 目標の作成・編集関連
    func queryObjectives()
    func createObjective(newObjective: Objective)
    func editObjective(objectiveId: UUID, newObjective: Objective)
    func deleteObjective(objectiveId: UUID)

    // 履歴関係
    func queryHistoryQuestBoards()
    func createHistoryQuestBoard(newHistoryQuestBoard: DailyQuestBoard)
    
    func queryTodayQuestBoard()
}

class AppDataService: AppDataServiceProtocol {
    // SwiftData用
    var modelContext: ModelContext? = nil
    var modelContainer: ModelContainer? = nil

    private var cancellables = Set<AnyCancellable>()
    
    private let activeQuestsSubject = CurrentValueSubject<[Quest], Never>([])
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    private let objectivesSubject = CurrentValueSubject<[Objective], Never>([])
    private let historyQuestBoardsSubject = CurrentValueSubject<[DailyQuestBoard], Never>([])
    private let todayQuestBoardSubject = CurrentValueSubject<DailyQuestBoard?, Never>(nil) // Publisher無し、データ保持用
    private let selectedQuestBoardSubject = CurrentValueSubject<DailyQuestBoard, Never>(DailyQuestBoard(id: UUID(), date: Date(timeIntervalSince1970: TimeInterval()), questSlots: []))

    // ==== Public publishers of lists ====
    var activeQuestsPubisher: AnyPublisher<[Quest], Never> { activeQuestsSubject.eraseToAnyPublisher() }
    var tasksPubisher: AnyPublisher<[Task], Never> { tasksSubject.eraseToAnyPublisher() }
    var objectivesPubisher: AnyPublisher<[Objective], Never> { objectivesSubject.eraseToAnyPublisher() }
    var historyQuestBoardsPubisher: AnyPublisher<[DailyQuestBoard], Never> { historyQuestBoardsSubject.eraseToAnyPublisher() }
    var selectedQuestBoardPublisher: AnyPublisher<DailyQuestBoard, Never> { selectedQuestBoardSubject.eraseToAnyPublisher() }

    @MainActor
    init () {
        // ==== 依存関係にあるデータの変更通知のWaterfallさせる ====
        // objectives -> tasks -> activeQuests -> selectedQuestBoard = todaySubjectBoard
        
        // objectives -> tasks
        objectivesPubisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] objectives in
                guard let self = self else { return }
                self.activeQuestsSubject.send(self.activeQuestsSubject.value)
                print("objectives->tasks")
            }
            .store(in: &cancellables)

        // tasks -> activeQuests
        tasksPubisher
            .receive(on: RunLoop.main)
            .sink { [weak self] tasks in
                guard let self = self else { return }
                self.activeQuestsSubject.send(self.activeQuestsSubject.value)
                print("tasks->activeQuests")
            }
            .store(in: &cancellables)
        
        // activeQuests -> selectedQuestBoard = todayQuestBoard
        activeQuestsPubisher
            .receive(on: RunLoop.main)
            .sink { [weak self] quests in
                guard let self = self else { return }
                self.selectedQuestBoardSubject.send(self.selectedQuestBoardSubject.value)
                print("quests->selectedQuestBoard")
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
        
        // SwiftDataの初期化
        initializeModelContainer()
    }

    private func createSampleData() {
       // モックの目標を作成
       let objective1 = Objective(id: UUID(), text: "健康的な生活を送る")
       let objective2 = Objective(id: UUID(), text: "勉強習慣を身につける")
       let objective3 = Objective(id: UUID(), text: "運動を習慣化する")
       
       // モックのタスクを作成
       let task1 = Task(id: UUID(), text: "朝7時に起床する", objective: objective1)
       let task2 = Task(id: UUID(), text: "朝食を食べる", objective: objective1)
       let task3 = Task(id: UUID(), text: "1時間勉強する", objective: objective2)
       let task4 = Task(id: UUID(), text: "30分ジョギングする", objective: objective3)
       let task5 = Task(id: UUID(), text: "ストレッチをする", objective: objective3)
       
       // モックの報酬を作成
       let reward1 = Reward(id: UUID(), text: "好きなお菓子を1つ買う")
       let reward2 = Reward(id: UUID(), text: "映画を見る")
       
       // モックのクエストを作成
       let quest1 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward1, tasks: [task1, task2, task5])
       let quest2 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward2, tasks: [task4, task5])
        
       // Quest2は受注済にする
       let acceptedQuest2 = quest2.accept()
        
        // モックのQuestSlotを作成
        let questSlot1 = QuestSlot(id: UUID(), quest: quest1, acceptedQuest: nil)
        let questSlot2 = QuestSlot(id: UUID(), quest: quest2, acceptedQuest: acceptedQuest2)
        
        // モックのDailyQuestBoardを作成
        let dailyQuestBoard = DailyQuestBoard(
            id: UUID(),
            date: Date(),
            questSlots: [questSlot1, questSlot2]
        )
        
        // サンプルデータを作成
        createObjective(newObjective: objective1)
        createObjective(newObjective: objective2)
        createObjective(newObjective: objective3)
        createTask(newTask: task1)
        createTask(newTask: task2)
        createTask(newTask: task3)
        createTask(newTask: task4)
        createTask(newTask: task5)
        createQuest(newQuest: quest1)
        createQuest(newQuest: quest2)
        todayQuestBoardSubject.send(dailyQuestBoard)
    }

    @MainActor
    private func initializeModelContainer() {
        do {
            let container = try ModelContainer(for: Quest.self, Task.self, Objective.self, DailyQuestBoard.self, QuestSlot.self, AcceptedQuest.self, AcceptedTask.self, Reward.self, RedeemableReward.self)
            modelContainer = container
            modelContext = container.mainContext
            modelContext?.autosaveEnabled = true

            loadLocalData()
            
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
    
    private func loadLocalData() {
        queryObjectives()
        queryTasks()
        queryActiveQuests()
        queryHistoryQuestBoards()
        queryTodayQuestBoard()
        if let todayQuestBoardSubjectValue = todayQuestBoardSubject.value {
            self.selectedQuestBoardSubject.send(todayQuestBoardSubjectValue)
        } else {
            // First time to load app
        }
    }

    // ==== Publishers for single items for each list ====
    func activeQuestPublisher(for id: UUID) ->  AnyPublisher<Quest?, Never> {
        activeQuestsSubject
            .map { quests in
                quests.first { $0.id == id }
            }
            .eraseToAnyPublisher()
    }
    func taskPublisher(for id: UUID) ->  AnyPublisher<Task?, Never> {
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

    // ==== Public methods ====
    func acceptQuest(questSlotId: UUID) {
        print("service.acceptQuest")
        updateTodayQuestBoard(questSlotId) { questSlot in
            // TODO: SwiftDataで永続化する必要がある
            return questSlot.acceptQuest()
        }
    }

    func toggleTaskCompletion(questSlotId: UUID, taskId: UUID) {
        updateTodayQuestBoard(questSlotId) { questSlot in
            // TODO: SwiftDataで永続化する必要がある
            guard var acceptedQuest = questSlot.acceptedQuest else { return questSlot }

            if let index = acceptedQuest.acceptedTasks.firstIndex(where: { $0.originalTask.id == taskId }) {
                let task = acceptedQuest.acceptedTasks[index]
                acceptedQuest.acceptedTasks[index] = task.isCompleted ?
                    AcceptedTask(originalTask: task.originalTask) : // 未完了に戻す
                    task.markAsCompleted() // 完了にする

                return QuestSlot(
                    id: questSlot.id,
                    quest: questSlot.quest,
                    acceptedQuest: acceptedQuest
                )
            }
            return questSlot
        }
    }

    func reportQuestCompletion(questSlotId: UUID) {
        updateTodayQuestBoard(questSlotId) { questSlot in
            // TODO: SwiftDataで永続化する必要がある
            guard let acceptedQuest = questSlot.acceptedQuest else { return questSlot}

            if !acceptedQuest.isAllTaskCompleted {return questSlot}

            return QuestSlot(
                id: questSlot.id,
                quest: questSlot.quest,
                acceptedQuest: acceptedQuest.reportCompletion()
            )
        }
    }

    func redeemTicket(questSlotId: UUID) {
        updateTodayQuestBoard(questSlotId) { questSlot in
            // TODO: SwiftDataで永続化する必要がある
            guard var acceptedQuest = questSlot.acceptedQuest else { return questSlot }

            acceptedQuest = acceptedQuest.redeemingReward()
            return QuestSlot(
                id: questSlot.id,
                quest: questSlot.quest,
                acceptedQuest: acceptedQuest
            )
        }
    }

    func discardAcceptedQuest(questSlotId: UUID) {
        updateTodayQuestBoard(questSlotId) { questSlot in
            // TODO: SwiftDataで永続化する必要がある
            return QuestSlot(
                id: questSlot.id,
                quest: questSlot.quest,
                acceptedQuest: nil
            )
        }
    }

    // MARK: - クエストの作成・編集関連 (SwiftData)
    func queryActiveQuests() {
        guard let modelContext = modelContext else { return }
        let fetchDescriptor = FetchDescriptor<Quest>()
        do {
            let quests = try modelContext.fetch(fetchDescriptor)
            activeQuestsSubject.send(quests)
            print("Queried Active Quests: \(quests.count)")
        } catch {
            print("Failed to fetch active quests: \(error)")
            activeQuestsSubject.send([])
        }
    }

    func createQuest(newQuest: Quest) {
        modelContext?.insert(newQuest)
        save()
        queryActiveQuests()
    }

    func editQuest(questId: UUID, newQuest: Quest) {
        guard let modelContext = modelContext else { return }
        let predicate = #Predicate<Quest> { $0.id == questId }
        var fetchDescriptor = FetchDescriptor<Quest>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let questToEdit = try modelContext.fetch(fetchDescriptor).first {
                // 値をコピーする (プロパティごとに更新)
                questToEdit.copyValues(from: newQuest)
                save()
                queryActiveQuests() // 更新後のリストを再フェッチして通知
            } else {
                print("Quest with id \(questId) not found for editing.")
            }
        } catch {
            print("Failed to fetch quest for editing: \(error)")
        }
    }

    func deleteQuest(questId: UUID) {
        guard let modelContext = modelContext else { return }
        let predicate = #Predicate<Quest> { $0.id == questId }
        var fetchDescriptor = FetchDescriptor<Quest>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let questToDelete = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(questToDelete)
                save()
                queryActiveQuests() // 削除後のリストを再フェッチして通知
            } else {
                print("Quest with id \(questId) not found for deletion.")
            }
        } catch {
            print("Failed to fetch quest for deletion: \(error)")
        }
    }

    // MARK: - タスクの作成・編集関連 (SwiftData)
    func queryTasks() {
        guard let modelContext = modelContext else { return }
        let fetchDescriptor = FetchDescriptor<Task>()
        do {
            let tasks = try modelContext.fetch(fetchDescriptor)
            tasksSubject.send(tasks)
            print("Queried Tasks: \(tasks.count)")
        } catch {
            print("Failed to fetch tasks: \(error)")
            tasksSubject.send([])
        }
    }

    func createTask(newTask: Task) {
        modelContext?.insert(newTask)
        save()
        queryTasks()
    }

    func editTask(taskId: UUID, newTask: Task) {
        guard let modelContext = modelContext else { return }
        let predicate = #Predicate<Task> { $0.id == taskId }
        var fetchDescriptor = FetchDescriptor<Task>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let taskToEdit = try modelContext.fetch(fetchDescriptor).first {
                taskToEdit.copyValues(from: newTask)
                save()
                queryTasks() // 更新後のリストを再フェッチして通知
            } else {
                print("Task with id \(taskId) not found for editing.")
            }
        } catch {
            print("Failed to fetch task for editing: \(error)")
        }
    }

    func deleteTask(taskId: UUID) {
        guard let modelContext = modelContext else { return }
        let predicate = #Predicate<Task> { $0.id == taskId }
        var fetchDescriptor = FetchDescriptor<Task>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let taskToDelete = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(taskToDelete)
                save()
                queryTasks() // 削除後のリストを再フェッチして通知
            } else {
                print("Task with id \(taskId) not found for deletion.")
            }
        } catch {
            print("Failed to fetch task for deletion: \(error)")
        }
    }

    // MARK: - 目標の作成・編集関連 (SwiftData)
    func queryObjectives() {
        guard let modelContext = modelContext else { return }
        let fetchDescriptor = FetchDescriptor<Objective>()
        do {
            let objectives = try modelContext.fetch(fetchDescriptor)
            objectivesSubject.send(objectives)
            print("Queried Objectives: \(objectives.count)")
        } catch {
            print("Failed to fetch objectives: \(error)")
            objectivesSubject.send([])
        }
    }

    func createObjective(newObjective: Objective) {
        modelContext?.insert(newObjective)
        save()
        queryObjectives()
    }

    func editObjective(objectiveId: UUID, newObjective: Objective) {
        guard let modelContext = modelContext else { return }
        let predicate = #Predicate<Objective> { $0.id == objectiveId }
        var fetchDescriptor = FetchDescriptor<Objective>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let objectiveToEdit = try modelContext.fetch(fetchDescriptor).first {
                objectiveToEdit.copyValues(from: newObjective)
                save()
                queryObjectives() // 更新後のリストを再フェッチして通知
            } else {
                print("Objective with id \(objectiveId) not found for editing.")
            }
        } catch {
            print("Failed to fetch objective for editing: \(error)")
        }
    }

    func deleteObjective(objectiveId: UUID) {
        guard let modelContext = modelContext else { return }
        let predicate = #Predicate<Objective> { $0.id == objectiveId }
        var fetchDescriptor = FetchDescriptor<Objective>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let objectiveToDelete = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(objectiveToDelete)
                save()
                queryObjectives() // 削除後のリストを再フェッチして通知
            } else {
                print("Objective with id \(objectiveId) not found for deletion.")
            }
        } catch {
            print("Failed to fetch objective for deletion: \(error)")
        }
    }

    // MARK: - 履歴関係 (SwiftData)
    func queryHistoryQuestBoards() {
        guard let modelContext = modelContext else { return }
        // 日付で降順にソート
        let sortDescriptor = SortDescriptor(\DailyQuestBoard.date, order: .reverse)
        let fetchDescriptor = FetchDescriptor<DailyQuestBoard>(sortBy: [sortDescriptor])
        do {
            let boards = try modelContext.fetch(fetchDescriptor)
            historyQuestBoardsSubject.send(boards)
            print("Queried History Quest Boards: \(boards.count)")
        } catch {
            print("Failed to fetch history quest boards: \(error)")
            historyQuestBoardsSubject.send([])
        }
    }

    // 当日のQuestBoardを取得または作成し、selectedQuestBoardSubjectに送信する
    func queryTodayQuestBoard() {
        guard let modelContext = modelContext else { return }

        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let todayEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return calendar.date(byAdding: components, to: todayStart)!
        }()

        let predicate = #Predicate<DailyQuestBoard> {
            $0.date >= todayStart && $0.date <= todayEnd
        }
        var fetchDescriptor = FetchDescriptor<DailyQuestBoard>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        do {
            if let todayBoard = try modelContext.fetch(fetchDescriptor).first {
                todayQuestBoardSubject.send(todayBoard)
                print("Found today's Quest Board.")
            } else {
                // 当日のボードが存在しない場合、新しく作成する
                print("Today's Quest Board not found, creating a new one.")
                let newBoard = createNewDailyQuestBoard(for: todayStart)
                modelContext.insert(newBoard)
                save()
                todayQuestBoardSubject.send(newBoard) // 新しいボードを送信
                queryHistoryQuestBoards() // 履歴リストも更新
            }
        } catch {
            print("Failed to fetch today's quest board: \(error)")
            // エラーが発生した場合でも、空のボードまたはデフォルトのボードを送信するか検討
            // selectedQuestBoardSubject.send(DailyQuestBoard(date: todayStart, questSlots: []))
        }
    }

    func createHistoryQuestBoard(newHistoryQuestBoard: DailyQuestBoard) {
        modelContext?.insert(newHistoryQuestBoard)
        save()
        queryHistoryQuestBoards()
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

    // ==== Private Helper methods ====
    private func save() {
        guard let modelContext = modelContext else {
            print("ModelContext is nil. Cannot save.")
            return
        }
        do {
            try modelContext.save()
            print("Data saved successfully.")
        } catch {
            // ここでのエラーハンドリングを改善する（例: ログ出力、UIへのフィードバック）
            print("Failed to save data: \(error)")
            // fatalErrorを避けるか、より詳細な情報を提供
        }
    }

    private func updateTodayQuestBoard(_ questSlotId: UUID, updateHandler: (QuestSlot) -> QuestSlot) {
        var questBoard = todayQuestBoardSubject.value
        if let todayQuestBoard = questBoard {
            if let index = todayQuestBoard.questSlots.firstIndex(where: { $0.id == questSlotId }) {
                todayQuestBoard.questSlots[index] = updateHandler(todayQuestBoard.questSlots[index])
                todayQuestBoardSubject.send(todayQuestBoard)
                save()
            }
        }
    }
    
    // Calendarインスタンスをクラスレベルで保持（パフォーマンスのため）
    private let calendar = Calendar.current
}
