import Foundation
import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaValpha010.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1_Valpha010]
    }
    
    static let migrateV1_Valpha010 = MigrationStage.custom(
        fromVersion: SchemaV1.self,
        toVersion: SchemaValpha010.self,
        willMigrate: nil
    ) { context in
        let quests = try? context.fetch(FetchDescriptor<SchemaValpha010.Quest>())
        
        quests?.forEach { quest in
            quest.archived = false
        }
        
        try? context.save()
    }
}
