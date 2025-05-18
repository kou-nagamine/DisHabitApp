//import Foundation
//import SwiftData
//
//enum MigrationPlan: SchemaMigrationPlan {
//    static var schemas: [any VersionedSchema.Type] {
//        [SchemaV1.self, SchemaValpha010.self]
//    }
//    
//    static var stages: [MigrationStage] {
//        [migrateV1_Valpha010]
//    }
//    static var migrateV1_Valpha010_newQuests = [SchemaValpha010.Quest]()
//    static let migrateV1_Valpha010 = MigrationStage.custom(
//        fromVersion: SchemaV1.self,
//        toVersion: SchemaValpha010.self,
//        willMigrate: { context in
//            let oldQuests = try? context.fetch(FetchDescriptor<SchemaV1.Quest>())
//            migrateV1_Valpha010_newQuests = oldQuests?.map { SchemaValpha010.Quest(
//                id: $0.id,
//                activatedDayOfWeeks: $0.activatedDayOfWeeks,
//                reward: SchemaValpha010.Reward(
//                    id: $0.reward.id,
//                    text: $0.reward.text),
//                tasks: $0.tasks.map { SchemaValpha010.StandbyTask(
//                    id: $0.id,
//                    text: $0.text,
//                    objective: $0.objective == nil ? nil : SchemaValpha010.Objective(
//                        id: $0.objective!.id,
//                        text: $0.objective!.text))  } ) } ?? []
//            try! context.delete(model: SchemaV1.Quest.self)
//            try! context.save()
//        },
//        didMigrate: { context in
//            migrateV1_Valpha010_newQuests.forEach { context.insert($0) }
//            try! context.save()
//        }
//    )
//}
