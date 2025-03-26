//
//  TabItem.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/23.
//

import Foundation

enum TabItem: String, CaseIterable {
    case home = "home"
    case task = "task"
    
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .task: "folder"
        }
    }
}
