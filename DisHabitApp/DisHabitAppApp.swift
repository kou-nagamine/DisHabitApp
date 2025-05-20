import SwiftUI
import SwiftData
import Foundation

@main
struct DisHabitAppApp: App {    
    var container: ModelContainer

    init() {
        let modelContainer: ModelContainer
        // Set up default location in Application Support directory
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directoryURL = appSupportURL.appendingPathComponent("DisHabit")
        
        // Set the path to the name of the store you want to set up
        let fileURL = directoryURL.appendingPathComponent("DisHabit.store")
        
        // Create a schema for your model (**Item 1**)
        let schema = Schema(versionedSchema: SchemaValpha011.self)
        
        do {
            // This next line will create a new directory called Example in Application Support if one doesn't already exist, and will do nothing if one already exists, so we have a valid place to put our store
            try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            
            // Create our `ModelConfiguration` (**Item 3**)
            let defaultConfiguration = ModelConfiguration("DisHabit", schema: schema, url: fileURL)
            
            do {
                // Create our `ModelContainer`
                modelContainer = try ModelContainer(
                    for: schema,
                    migrationPlan: MigrationPlan.self,
                    configurations: defaultConfiguration
                )
                
                self.container = modelContainer
             } catch {
                fatalError("Could not initialise the container…")
            }
        } catch {
            fatalError("Could not find/create Example folder in Application Support")
        }
        
//        do {
//            let storeURL = URL.documentsDirectory.appending(path: "database-debug.sqlite")
//            let config = ModelConfiguration(url: storeURL)
//            container = try ModelContainer(for: Quest.self, StandbyTask.self, Objective.self, DailyQuestBoard.self, QuestSlot.self, AcceptedQuest.self, AcceptedTask.self, Reward.self, RedeemableReward.self, configurations: config)
//        } catch {
//            fatalError("Failed to configure SwiftData container.")
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
