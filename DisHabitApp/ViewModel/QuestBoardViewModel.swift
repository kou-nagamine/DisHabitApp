//
//  QuestBoardViewModel.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/11.
//

import Foundation
import Combine
import Dependencies

class QuestBoardViewModel: ObservableObject {
    // dailyQuestのdata
    @Published var dailyQuestBoard: DailyQuestBoard = DailyQuestBoard(id: UUID(), date: Date(timeIntervalSince1970: TimeInterval()), questSlots: [])
    
    @Dependency(\.appDataService) var appDataService
    private var cancellables = Set<AnyCancellable>()
    
    // 依存性注入を使用したイニシャライザ
    init() {
        // 変更通知を購読
        self.appDataService.selectedQuestBoardPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.dailyQuestBoard, on: self) //　新しいデータをdailyQuestBoardに代入する
            .store(in: &cancellables)
    }
    
    func acceptQuest(questSlotId: UUID) async {
        print("vm.acceptQuest")
        await appDataService.acceptQuest(questSlotId: questSlotId)
    }
    
    func debug_ResetAcceptedQuests() async {
        await appDataService.debug_ResetAcceptedQuests()
    }
    
    func debug_ReloadTodayQuestBoard() async {
        await appDataService.debug_ReloadTodayQuestBoard()
    }
}
