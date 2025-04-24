//
//  Router.swift
//  DisHabitApp
//
//  Created by nafell on 2025/04/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var detailsNavigationPath = NavigationPath()
    
    static let shared: Router = Router()
}
