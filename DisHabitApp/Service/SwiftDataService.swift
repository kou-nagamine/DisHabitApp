//import Foundation
//import SwiftData
//
//actor SwiftDataService {
//    private var modelContext: ModelContext
//    private var modelContainer: ModelContainer
//    
//    init(modelContainer: ModelContainer) {
//        self.modelContainer = modelContainer
//        let context = ModelContext(modelContainer)
//        context.autosaveEnabled = true
//        self.modelContext = context
//    }
//
//    // ==== クエストの作成・編集関連 ====
//    func createQuest(newQuest: Quest) throws {
//        modelContext.insert(newQuest)
//        try modelContext.save()
//    }
//
//    func editQuest(questId: UUID, newQuest: Quest) throws {
//        guard let quest = try fetchQuest(by: questId) else { return } // TODO: Error handling
//        quest.activatedDayOfWeeks = newQuest.activatedDayOfWeeks
//        quest.reward = newQuest.reward // Assuming Reward is Codable or handled appropriately
//        quest.tasks = newQuest.tasks // Assuming Task is Codable or handled appropriately
//        try modelContext.save()
//    }
//
//    func deleteQuest(questId: UUID) throws {
//        guard let quest = try fetchQuest(by: questId) else { return } // TODO: Error handling
//        modelContext.delete(quest)
//        try modelContext.save()
//    }
//
//    func fetchQuests() throws -> [Quest] {
//        let descriptor = FetchDescriptor<Quest>(sortBy: [SortDescriptor(\.id)]) // TODO: Sorting
//        return try modelContext.fetch(descriptor)
//    }
//
//    private func fetchQuest(by id: UUID) throws -> Quest? {
//        let predicate = #Predicate<Quest> { $0.id == id }
//        let descriptor = FetchDescriptor<Quest>(predicate: predicate)
//        let results = try modelContext.fetch(descriptor)
//        return results.first
//    }
//
//    // ==== タスクの作成・編集関連 ====
//    func createTask(newTask: StandbyTask) throws {
//        modelContext.insert(newTask)
//        try modelContext.save()
//    }
//
//    func editTask(taskId: UUID, newTask: StandbyTask) throws {
//        guard let task = try fetchTask(by: taskId) else { return } // TODO: Error handling
//        task.text = newTask.text
//        task.objective = newTask.objective // Assuming Objective relationship is handled
//        try modelContext.save()
//    }
//
//    func deleteTask(taskId: UUID) throws {
//        guard let task = try fetchTask(by: taskId) else { return } // TODO: Error handling
//        modelContext.delete(task)
//        try modelContext.save()
//    }
//
//    func fetchTasks() throws -> [StandbyTask] {
//        let descriptor = FetchDescriptor<StandbyTask>(sortBy: [SortDescriptor(\.id)]) // TODO: Sorting
//        return try modelContext.fetch(descriptor)
//    }
//
//    private func fetchTask(by id: UUID) throws -> StandbyTask? {
//        let predicate = #Predicate<StandbyTask> { $0.id == id }
//        let descriptor = FetchDescriptor<StandbyTask>(predicate: predicate)
//        let results = try modelContext.fetch(descriptor)
//        return results.first
//    }
//
//    // ==== 目標の作成・編集関連 ====
//    func createObjective(newObjective: Objective) throws {
//        modelContext.insert(newObjective)
//        try modelContext.save()
//    }
//
//    func editObjective(objectiveId: UUID, newObjective: Objective) throws {
//        guard let objective = try fetchObjective(by: objectiveId) else { return } // TODO: Error handling
//        objective.text = newObjective.text
//        try modelContext.save()
//    }
//
//    func deleteObjective(objectiveId: UUID) throws {
//        guard let objective = try fetchObjective(by: objectiveId) else { return } // TODO: Error handling
//        modelContext.delete(objective)
//        try modelContext.save()
//    }
//
//    func fetchObjectives() throws -> [Objective] {
//        let descriptor = FetchDescriptor<Objective>(sortBy: [SortDescriptor(\.id)]) // TODO: Sorting
//        return try modelContext.fetch(descriptor)
//    }
//
//     private func fetchObjective(by id: UUID) throws -> Objective? {
//        let predicate = #Predicate<Objective> { $0.id == id }
//        let descriptor = FetchDescriptor<Objective>(predicate: predicate)
//        let results = try modelContext.fetch(descriptor)
//        return results.first
//    }
//
//    // ==== 履歴関係 ====
//    func createQuestBoard(newQuestBoard: DailyQuestBoard) throws {
//        modelContext.insert(newQuestBoard)
//        try modelContext.save()
//    }
//
//    func fetchHistoryQuestBoards() throws -> [DailyQuestBoard] {
//        let descriptor = FetchDescriptor<DailyQuestBoard>(sortBy: [SortDescriptor(\.date, order: .reverse)])
//        return try modelContext.fetch(descriptor)
//    }
//    
//    func fetchDailyQuestBoard(for date: Date) throws -> DailyQuestBoard? {
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: date)
//
//        let predicate = #Predicate<DailyQuestBoard> {
//            $0.date == startOfDay
//        }
//        let descriptor = FetchDescriptor<DailyQuestBoard>()
//        return try modelContext.fetch(descriptor).first
//    }
//    
//    func updateDailyQuestBoard(_ board: DailyQuestBoard) throws {
//        // No need to explicitly insert if the object is already managed.
//        // SwiftData tracks changes automatically. Just ensure save is called.
//        try modelContext.save()
//    }
//    
//    func debug_deleteTodayQuestBoard() throws {
//        if let todayQuestBoard = try fetchDailyQuestBoard(for: Date()) {
//            modelContext.delete(todayQuestBoard)
//            try modelContext.save()
//        }
//    }
//}
