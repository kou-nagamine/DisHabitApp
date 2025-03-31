//
//  TabItem.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/23.
//

import Foundation

/// Represents the available tabs in the TabBar
enum TabItem: String, CaseIterable {
    case home = "home" /// Home screen tab
    case task = "task" /// Task screeen tab
    
    /// Returns the SF Symbol name for each tab
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .task: "folder"
        }
    }
}
