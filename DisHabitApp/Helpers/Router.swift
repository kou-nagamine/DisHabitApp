//
//  Router.swift
//  DisHabitApp
//
//  Created by nafell on 2025/04/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    static let shared: Router = Router()
}
