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
    
    func acceptQuest(questSlotId: UUID) {
        print("vm.acceptQuest")
        appDataService.acceptQuest(questSlotId: questSlotId)
    }
}
