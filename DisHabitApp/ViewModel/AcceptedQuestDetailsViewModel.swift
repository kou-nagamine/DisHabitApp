import Foundation
import Combine
import Dependencies

class AcceptedQuestDetailsViewModel: ObservableObject {
    @Published var acceptedQuest: AcceptedQuest
    
    @Dependency(\.appDataService) var appDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(acceptedQuest: AcceptedQuest) {
        self.acceptedQuest = acceptedQuest
        self.appDataService.selectedQuestBoardPublisher
            .receive(on: RunLoop.main)
            .map ({
                $0.questSlots.first(where: { $0.acceptedQuest == acceptedQuest }).map({$0.acceptedQuest})!!
            })
            .assign(to: \.acceptedQuest, on: self)
            .store(in: &cancellables)
    }
    
    func toggleTaskCompleted() {
        
    }
}
