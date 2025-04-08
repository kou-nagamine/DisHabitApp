import Foundation
import Combine
import Dependencies

class ObjectivesPageViewModel: ObservableObject {
    @Published var objectives: [Objective] = []

    @Dependency(\.appDataService) var appDataService
    private var cancellables = Set<AnyCancellable>()

    init() {
        appDataService.objectivesPubisher
            .receive(on: RunLoop.main)
            .assign(to: \.objectives, on: self)
            .store(in: &cancellables)

        _Concurrency.Task {
            await appDataService.queryObjectives()
        }
    }
}
