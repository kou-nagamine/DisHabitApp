//import Foundation
//import Combine
//import Dependencies
//
//class TasksPageViewModel: ObservableObject {
//    @Published var selectedObjective: Objective
//    @Published var tasks: [StandbyTask] = []
//
//    @Dependency(\.appDataService) var appDataService
//    private var cancellables = Set<AnyCancellable>()
//
//    init(selectedObjective: Objective) {
//        self.selectedObjective = selectedObjective
//        
//        appDataService.tasksPubisher
//            .receive(on: RunLoop.main)
//            .map { tasks in
//                tasks.filter { task in
//                    if let objective = task.objective {
//                        if objective.id == selectedObjective.id {
//                            return true
//                        }
//                        return false
//                    } else {
//                        return false
//                    }
//                }
//            }
//            .assign(to: \.tasks, on: self)
//            .store(in: &cancellables)
//
//        _Concurrency.Task {
//            await appDataService.queryTasks()
//        }
//    }
//}
