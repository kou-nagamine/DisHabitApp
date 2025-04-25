import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    static let shared: Router = Router()
}


// Reference: https://stackoverflow.com/questions/74808737/where-to-place-global-navigationpath-in-swiftui
