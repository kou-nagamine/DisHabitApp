import SwiftUI
import SwiftData
import Foundation

@main
struct DisHabitAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Objective.self], isUndoEnabled: true)
    }
}
