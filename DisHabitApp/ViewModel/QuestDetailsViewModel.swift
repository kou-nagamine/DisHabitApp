import Foundation
import Combine
import Dependencies

class QuestDetailsViewModel: ObservableObject {
    @Published var questSlot: QuestSlot
    
    @Dependency(\.appDataService) var appDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(questSlot: QuestSlot) {
        self.questSlot = questSlot
        self.appDataService.selectedQuestBoardPublisher
            .receive(on: RunLoop.main)
            .map ({
                $0.questSlots.first(where: { $0.id == questSlot.id }) ?? questSlot
            })
            .assign(to: \.questSlot, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: standbyQuest
    func acceptQuest() async {
        await appDataService.acceptQuest(questSlotId: questSlot.id)
    }
    
    // MARK: acceptedQuest
    func toggleTaskCompleted(acceptedTask: AcceptedTask) async {
        await appDataService.toggleTaskCompletion(questSlotId: questSlot.id, taskId: acceptedTask.id)
    }
    
    func discardAcceptedQuest() async {
        await appDataService.discardAcceptedQuest(questSlotId: questSlot.id)
    }
    
    func reportQuestCompletion() async {
        await appDataService.reportQuestCompletion(questSlotId: questSlot.id)
    }
    
    func redeemTicket() async {
        await appDataService.redeemTicket(questSlotId: questSlot.id)
    }
}
