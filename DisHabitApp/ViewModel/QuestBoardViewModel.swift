//
//  QuestBoardViewModel.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/11.
//

//import Foundation
//import Combine
//
//class QuestBoardViewModel: ObservableObject {
//    
//    // dailyQuestのdata
//    @Published var dailyQuestBoard: DailyQuestBoard = DailyQuestBoard(id: UUID(), date: Date(timeIntervalSince1970: TimeInterval()), questSlots: [])
//    private let appDataService: AppDataServiceProtocol
//    private var cancellables = Set<AnyCancellable>()
//        
//    // 依存性注入を使用したイニシャライザ
//    init(appDataService: AppDataServiceProtocol = AppDataService()) {
//        self.appDataService = appDataService
//        // 変更通知を購読
//        appDataService.selectedQuestBoardPublisher
//            .receive(on: RunLoop.main)
//            .assign(to: \.dailyQuestBoard, on: self) ///　新しいデータをdailyQuestBoardに代入する
//            .store(in: &cancellables)
//    }
//    
//    func acceptQuest(questSlotId: UUID) {
//        appDataService.acceptQuest(questSlotId: questSlotId)
//    }
//}
