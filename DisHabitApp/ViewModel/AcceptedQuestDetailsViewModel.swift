import Foundation
import Combine

class AcceptedQuestDetailsViewModel: ObservableObject {
//    @Published var acceptedQuest: AcceptedQuest
    
    private let appDataService: AppDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // 編集
    init(appDataService: AppDataService, acceptedQuest: AcceptedQuest) {
        self.appDataService = appDataService
//        self.appDataService.selectedQuestBoardPublisher
//            .receive(on: RunLoop.main)
//            .filter { $0.questSlots != nil }
//            .map{ dailyQuestBoard in
//                dailyQuestBoard.questSlots.first(where: { $0.acceptedQuest.id == acceptedQuest.id })!
//            }
//            .sink { [weak self] questSlot in
//                guard let self = self else {return}
//                self.acceptedQuest =
//            }
                
    }
}
