import Foundation
import Combine

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
    func createQuest(newQuest: Quest)
    func editQuest(questId: UUID, newQuest: Quest)
    func deleteQuest(questId: UUID)

    // タスクの作成・編集関連
    func createTask(newTask: Task)
    func editTask(taskId: UUID, newTask: Task)
    func deleteTask(taskId: UUID)

    // 目標の作成・編集関連
    func createObjective(newObjective: Objective)
    func editObjective(objectiveId: UUID, newObjective: Objective)
    func deleteObjective(objectiveId: UUID)
}

class AppDataService: AppDataServiceProtocol {
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
    
    
    init () {
        loadSampleData()

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
        
        // selectedQuestBoard -> todayQuestBoard
        selectedQuestBoardSubject
            .receive(on: RunLoop.main)
            .filter { $0.date == Date() } // ユーザが当日のクエスト一覧を表示している時だけ発火させたい。
            .sink { [weak self] quests in
                guard let self = self else { return }
                self.todayQuestBoardSubject.send(self.selectedQuestBoardSubject.value) // ここは値をコピーしたい
                
            }
            .store(in: &cancellables)
        
        
    }

    private func loadSampleData() {
        // Create mock data for activeQuests.
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
        let quest1 = Quest(id: UUID(), title: "健康的な朝習慣", reward: reward1, tasks: [task1, task2, task5])
        let quest2 = Quest(id: UUID(), title: "運動チャレンジ", reward: reward2, tasks: [task4, task5])
        
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
        
        // Subjectsを更新
        objectivesSubject.send([objective1, objective2, objective3])
        tasksSubject.send([task1, task2, task3, task4, task5])
        activeQuestsSubject.send([quest1, quest2])
        selectedQuestBoardSubject.send(dailyQuestBoard)
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
        updateSelectedQuestBoard(questSlotId) { questSlot in
            return questSlot.acceptQuest()
        }
    }

    func toggleTaskCompletion(questSlotId: UUID, taskId: UUID) {
        updateTodayQuestBoard(questSlotId) { questSlot in
            guard var acceptedQuest = questSlot.acceptedQuest else { return questSlot }

            if let index = acceptedQuest.acceptedTasks.firstIndex(where: { $0.id == taskId }) {
                let task = acceptedQuest.acceptedTasks[index]
                acceptedQuest.acceptedTasks[index] = task.isCompleted ? 
                    AcceptedTask(originalTask: task.originalTask) :
                    task.markAsCompleted()

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
            return QuestSlot(
                id: questSlot.id,
                quest: questSlot.quest,
                acceptedQuest: nil
            )
        }
    }

    func createQuest(newQuest: Quest) {
        var quests = activeQuestsSubject.value
        quests.append(newQuest)
        activeQuestsSubject.send(quests)
    }
    
    func editQuest(questId: UUID, newQuest: Quest) {
        let quests = activeQuestsSubject.value
        if let index = quests.firstIndex(where: { $0.id == questId }) {
            quests[index].copyValues(from: newQuest)
            activeQuestsSubject.send(quests)
        }
    }
    
    func deleteQuest(questId: UUID) {
        var quests = activeQuestsSubject.value
        quests.removeAll { $0.id == questId }
        activeQuestsSubject.send(quests)
    }
    
    func createTask(newTask: Task) {
        var tasks = tasksSubject.value
        tasks.append(newTask)
        tasksSubject.send(tasks)
    }
    
    func editTask(taskId: UUID, newTask: Task) {
        let tasks = tasksSubject.value
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].copyValues(from: newTask)
            tasksSubject.send(tasks)
        }
    }
    
    func deleteTask(taskId: UUID) {
        var tasks = tasksSubject.value
        tasks.removeAll { $0.id == taskId }
        tasksSubject.send(tasks)
    }
    
    func createObjective(newObjective: Objective) {
        var objectives = objectivesSubject.value
        objectives.append(newObjective)
        objectivesSubject.send(objectives)
    }
    
    func editObjective(objectiveId: UUID, newObjective: Objective) {
        let objectives = objectivesSubject.value
        if let index = objectives.firstIndex(where: { $0.id == objectiveId }) {
            objectives[index].copyValues(from: newObjective)
            objectivesSubject.send(objectives)
        }
    }
    
    func deleteObjective(objectiveId: UUID) {
        var objectives = objectivesSubject.value
        objectives.removeAll { $0.id == objectiveId }
        objectivesSubject.send(objectives)
    }

    func editTask(taskId: UUID, newText: String) {
        updateTask(taskId) { task in
            task.text = newText
            return task
        }
    }


    // ==== Helper methods of updating handlers ====
    private func updateTodayQuestBoard(_ questSlotId: UUID, updateHandler: (QuestSlot) -> QuestSlot) {
        var dailyQuestBoards = historyQuestBoardsSubject.value
        if let index = dailyQuestBoards.firstIndex(where: { $0.date >= Date() }) { // このhandlerは当日以降のQuestBoardの更新にのみ使われる。過去は閲覧専用であることが想定されている。
            dailyQuestBoards[index].questSlots = dailyQuestBoards[index].questSlots.map { questSlot in
                questSlot.id == questSlotId ? updateHandler(questSlot) : questSlot // 該当のquestSlotを更新する
            }
            historyQuestBoardsSubject.send(dailyQuestBoards)
        }
    }
    
    private func updateSelectedQuestBoard(_ questSlotId: UUID, updateHandler: (QuestSlot) -> QuestSlot) {
        var selectedQuestBoard = selectedQuestBoardSubject.value
        selectedQuestBoard.questSlots = selectedQuestBoard.questSlots.map { questSlot in
            questSlot.id == questSlotId ? updateHandler(questSlot) : questSlot 
        }
        selectedQuestBoardSubject.send(selectedQuestBoard)
    }
    
    private func updateTask(_ taskId: UUID, updateHandler: (Task) -> Task) {
        var tasks = tasksSubject.value
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index] = updateHandler(tasks[index])
            tasksSubject.send(tasks)
        }
    }
}
