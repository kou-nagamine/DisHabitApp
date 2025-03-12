import SwiftUI

@main
struct DisHabitAppApp: App {
    @StateObject private var dateModel = DateModel()    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dateModel)
        }
    }
}
