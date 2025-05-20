import Foundation
import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaValpha010.self, SchemaValpha011.self]
    }
    
    static var stages: [MigrationStage] {
        [migrate010_011]
    }
    static var Valpha011_newQuests = [SchemaValpha011.Quest]()
    static var Valpha011_newStandbyTasks = [SchemaValpha011.StandbyTask]()
    static let migrate010_011 = MigrationStage.custom(
        fromVersion: SchemaValpha010.self,
        toVersion: SchemaValpha011.self,
        willMigrate: { context in
            
            let oldQuests = try? context.fetch(FetchDescriptor<SchemaValpha010.Quest>())
            let oldStandbyTasks = try? context.fetch(FetchDescriptor<SchemaValpha010.StandbyTask>())
            
            var q_st_dict: [UUID:[SchemaValpha011.StandbyTask]] = [:]
            
            for quest in oldQuests ?? [] {
                var questTasks: [SchemaValpha011.StandbyTask] = []
                for task in quest.tasks {
                    let newTask =
                        SchemaValpha011.StandbyTask(
                            id: task.id,
                            text: task.text,
                            objective: task.objective == nil ? nil : SchemaValpha011.Objective(
                                id: task.objective!.id,
                                text: task.objective!.text))
                    questTasks.append(newTask)
                    Valpha011_newStandbyTasks.append(newTask)
                }
                q_st_dict[quest.id] = questTasks
            }
            
            Valpha011_newQuests = oldQuests?.map { SchemaValpha011.Quest(
                id: $0.id,
                activatedDayOfWeeks: $0.activatedDayOfWeeks,
                reward: SchemaValpha011.Reward(
                    id: $0.reward.id,
                    text: $0.reward.text),
                tasks: q_st_dict[$0.id] ?? []
            )} ?? []
            
            
            try! context.delete(model: SchemaValpha010.Quest.self)
            try! context.delete(model: SchemaValpha010.StandbyTask.self)
            try! context.save()
        },
        didMigrate: { context in
            Valpha011_newQuests.forEach { context.insert($0) }
            Valpha011_newStandbyTasks.forEach { context.insert($0) }
            try! context.save()
        }
    )
}
