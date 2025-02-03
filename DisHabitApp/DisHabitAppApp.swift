//
//  DisHabitAppApp.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

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
