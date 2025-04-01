import SwiftUI
import SwiftData
import Foundation
import DI

@main
struct DisHabitAppApp: App {
    private let appDataService = AppDataService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(appDataService: appDataService)
        }
    }
}
