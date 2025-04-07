import SwiftUI
import SwiftData
import Foundation

@main
struct DisHabitAppApp: App {
    private let appDataService = AppDataService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
