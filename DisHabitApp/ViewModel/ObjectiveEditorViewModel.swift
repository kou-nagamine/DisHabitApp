//import Foundation
//import Combine
//
//class ObjectiveEditorViewModel: ObservableObject {
//    @Published var objective: Objective
//    @Published var isAddingNewObjective: Bool // true:新規作成 false:編集
//    
//    private let appDataService: AppDataServiceProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//    // 編集
//    init(appDataService: AppDataService, objective: Objective) {
//        isAddingNewObjective = false
//        self.appDataService = appDataService
//        self.objective = objective.deepCopy()
//    }
//    
//    // 新規作成
//    init(appDataService: AppDataService) {
//        isAddingNewObjective = true
//        self.appDataService = appDataService
//        self.objective = Objective(id:UUID(), text: "")
//    }
//}
