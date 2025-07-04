import Foundation
import SwiftUI
import SwiftData

struct QuestBoardView: View {
    @Binding var selectedDate: Date
    @Binding var showTabBar: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    var tense: QuestBoardTense {
        let today = Date()
        if self.selectedDate.isSameDayAs(today) {
            return .today
        } else if self.selectedDate < today { // isSameDayAsに引っかからなかったモノのみここに到達するので、小なり現在時刻でOK
            return .past
        } else {
            return .future
        }
    }
    
    @Query(filter: #Predicate<Quest> {quest in
        quest.isArchived == false
    }) var standbyQuests: [Quest]
    @Query var dailyQuestBoards: [DailyQuestBoard]
//    @Query var objectives: [Objective] //temp
//    @Query var tasks: [StandbyTask] //temp!!
    @Query var qs: [QuestSlot] //temp!!
    
    @State private var currentQuestSlotManagers: [QuestSlotManager] = []
    
    @MainActor
    private func updateBoardManagers(for date: Date) {
        print("Updating board managers for date: \(date), tense: \(date.tense())")
        // 既存のボードを探す
        if let board = dailyQuestBoards.first(where: { $0.date.isSameDayAs(date)}) {
            print("Found existing board for \(date)")
            currentQuestSlotManagers = board.questSlots.map {
                QuestSlotManager(
                    modelContext: modelContext,
                    board: board,
                    questSlot: $0,
                    tense: date.tense() // tenseを渡す
                )
            }
            // standbyQuestsとboardのquestSlotを比較し、差分に対して処理する
            // 未来のboardを表示している最中にクエストが複数追加されている状態→当日boardに切り替える操作があり得る
            // add/archiveしたときに全対象boardに対して更新処理を行うのではなく、表示をリクエストされた段階で差分更新処理を実行する
            if date.tense() != .past {
                var todayQuests: [Quest] = standbyQuests.filter { $0.activatedDayOfWeeks[date.weekday()] == true }
                let currentCount =  currentQuestSlotManagers.count
                let standbyCount = todayQuests.count
                if currentCount < standbyCount { // クエストが増えていた時
                    print("Quests have increased for this day. Creating corresponding questSlot...")
                    // 差分のクエスト(新規作成されたクエスト)を取り出す
                    for q in currentQuestSlotManagers {
                        todayQuests = todayQuests.filter { $0.id != q.questSlot.quest.id } // 既存Questから1つずつ消去する
                    }
                    
                    // 差分からQuestSlot+Managerを作成する
                    for q in todayQuests {
                        let questSlot = QuestSlot(board: board, quest: q)
                        modelContext.insert(questSlot)
                        let manager = QuestSlotManager(modelContext: modelContext, board: board, questSlot: questSlot, tense: .today)
                        currentQuestSlotManagers.append(manager)
                        
                        // バグ対処用: 意味のない状態遷移を起こして正常な表示にする。力技。
                        Task {
                            await manager.acceptQuest()
                            await manager.discardAcceptedQuest()
                        }
                    }
                } else if currentCount > standbyCount { // クエストが減っていた時
                    print("Quests have decreased for this day. Removing corresponding questSlot...")
                    // 削除アクションの方でvalidateするので、ここでは問答無用で削除する
                    let archived = currentQuestSlotManagers.filter { $0.questSlot.quest.isArchived }
                    for qsm in archived {
                        currentQuestSlotManagers = currentQuestSlotManagers.filter { $0.questSlot.quest.id != qsm.questSlot.quest.id }
                        board.questSlots = board.questSlots.filter { $0.quest.id != qsm.questSlot.quest.id }
                        modelContext.delete(qsm.questSlot)
                    }
                } else {
                    // 何もしない
                }
            }
        } else {
            // 存在しない場合のみボードを作成
            print("No board found for \(date). Determining action based on tense.")
            switch tense {
            case .today, .future:
                // 未来または今日のボードは作成する
                print("Creating board for today/future date.")
                currentQuestSlotManagers = createQuestBoard(for: date) // 日付を渡して作成
            case .past:
                // 過去のボードは作成しない
                print("Not creating board for past date.")
                currentQuestSlotManagers = [] // 空にする
            }
        }
        print("Finished updating board managers. Count: \(currentQuestSlotManagers.count)")
    }
    
    @MainActor
    private func createQuestBoard(for date: Date) -> [QuestSlotManager] {
        
        print("Creating new DailyQuestBoard for \(date)")

        
        let newBoard = DailyQuestBoard(date: date, questSlots: [])
        
        // activeQuestsの中から、指定された日付の曜日を持つQuestからQuestSlotを作成
        let questSlots = standbyQuests.filter { $0.activatedDayOfWeeks[date.weekday()] == true }.map { QuestSlot(board:newBoard, quest: $0) }
        
        for questSlot in questSlots {
            modelContext.insert(questSlot)
        }
        
        print("Found \(questSlots.count) quests for \(date.formatted(date: .long, time: .omitted)) (Weekday: \(date.weekday()))")

        
        let questSlotManagers = questSlots.map { QuestSlotManager(
            modelContext: modelContext, board: newBoard, questSlot: $0, tense: tense) } // tenseを渡す

        // .today の場合のみSwiftDataに保存
        if tense == .today {
            // 既に同じ日付のボードがないか最終確認 (より安全にするため)
            // Note: ModelContextの操作はメインスレッドで行うのが基本
            let existingBoard = dailyQuestBoards.first { $0.date.isSameDayAs(date) }
            if existingBoard == nil {
                 modelContext.insert(newBoard)
                 print("Inserted new board for \(date)")
                 // 保存後、変更を反映させるために必要であれば try? modelContext.save() を呼ぶ
                 // try? modelContext.save()
            } else {
                 print("Board for \(date) already exists, skipping insertion.")
                 // ここで既存ボードのManagerを返す方が一貫性があるかもしれない
                 // return existingBoard!.questSlots.map { QuestSlotManager(modelContext: modelContext, board: existingBoard!, questSlot: $0, tense: tense) }
            }
        } else {
            print("Skipping insertion for future date \(date)")
        }
        
       do {
           try modelContext.save()
       } catch {
           print("Failed to save: \(error)")
       }
        
        return questSlotManagers
    }
   
    var screenWidth: CGFloat {
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let window = windowScene.windows.first else {
           return 0
       }
       return window.screen.bounds.width
    }
    
    // MARK: BODY =================================================================================================================
   
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // タイトル
            Text("楽しいこと習慣")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 18)
                .padding(.leading, 20)
                .padding(.bottom, 18)
            // クエストリスト
            ScrollView(.vertical) {
                Spacer() // 要検討
                VStack(spacing: 18) {
#if DEBUG
//                    VStack{
//                        Button {
//                            let boards = dailyQuestBoards /*.filter { $0.date.isSameDayAs(self.selectedDate)}*/
//                            print("Found \(boards.count) boards")
//                            print("QS: \(qs.count)")
//                            for board in boards {
//                                print("Removing board")
//                                modelContext.delete(board)
//                            }
//                            for q in qs {
//                                print("Removing QuestSlot")
//                                modelContext.delete(q)
//                            }
//                            do {
//                                try modelContext.save()
//                                print("removed stuff")
//                            } catch {
//                                print("Failed to save: \(error)")
//                            }
//                        } label: {
//                            Text("Board削除")
//                        }
//                        
//                        Button {
//                            print("boards:", dailyQuestBoards.count)
//                            for board in dailyQuestBoards {
//                                print(board.date)
//                            }
////                            print("questSlots:", qs.count)
////                            for q in qs {
////                                print(q.quest.reward.text)
////                            }
////                            _Concurrency.Task {
////                                await vm.debug_ResetAcceptedQuests()
////                            }
//                            print("qs managers", currentQuestSlotManagers.count)
//                        } label: {
//                            Text("print")
//                        }
//                        
//                        Button {
//                            do {
////                                try modelContext.delete(model: DailyQuestBoard.self)
////                                try modelContext.delete(model: DailyQuestBoard.self)
//                                //                            let a = tasks
//                                //                            let b = objectives
//                                //                            let c = standbyQuests
//                                
//                                let objective1 = Objective(id: UUID(), text: "健康的な生活を送る")
//                                let objective2 = Objective(id: UUID(), text: "勉強習慣を身につける")
//                                let objective3 = Objective(id: UUID(), text: "運動を習慣化する")
//                                
//                                let task1 = StandbyTask(id: UUID(), text: "朝7時に起床する", objective: objective1)
//                                let task2 = StandbyTask(id: UUID(), text: "朝食を食べる", objective: objective1)
//                                let task3 = StandbyTask(id: UUID(), text: "1時間勉強する", objective: objective2)
//                                let task4 = StandbyTask(id: UUID(), text: "30分ジョギングする", objective: objective3)
//                                let task5 = StandbyTask(id: UUID(), text: "ストレッチをする", objective: objective3)
//                                
////                                let reward1 = Reward(id: UUID(), text: "好きなお菓子を1つ買う")
////                                let reward2 = Reward(id: UUID(), text: "映画を見る")
//                                
////                                let quest1 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward1, tasks: [task1, task2, task5])
////                                let quest2 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward2, tasks: [task4, task5])
//                                
//                                
//                                modelContext.insert(objective1)
//                                modelContext.insert(objective2)
//                                modelContext.insert(objective3)
//                                modelContext.insert(task1)
//                                modelContext.insert(task2)
//                                modelContext.insert(task3)
//                                modelContext.insert(task4)
//                                modelContext.insert(task5)
////                                modelContext.insert(reward1)
////                                modelContext.insert(reward2)
////                                modelContext.insert(quest1)
////                                modelContext.insert(quest2)
//                                
//                                try modelContext.save()
//                                
//                                print("Deleted board & qs table")
//                            } catch {
//                                print("Failed to clear board & qs table: \(error)")
//                            }
//                        } label: {
//                            Text("Board/QSテーブルをリセット")
//                        }
//                    }
#endif
                    
                    if currentQuestSlotManagers.count > 0 {
                        ForEach(currentQuestSlotManagers) { manager in
                            VStack{
                                
                                QuestSlotContainer(manager: manager, showTabBar: $showTabBar)
                            }
                        }
                    } else {
                        Text("クエストがありません。") // TODO: ボタンを追加
                    }
                    
                    List { } // ↑の内容をリストに書いても動作しない。RPのトリガーとして以下のハンドラを記述している
                        .onChange(of: selectedDate) { _, newDate in // selectedDate の変更を監視
                            updateBoardManagers(for: newDate)
                        }
                        .onChange(of: standbyQuests) { _, quests in
                            print("onChange(of: standbyQuests)")
                            updateBoardManagers(for: selectedDate)
                        }
                        .onAppear { // 最初に表示されたときにも更新
                            updateBoardManagers(for: selectedDate)
                        }
                    
                }
                .padding(.bottom, 120)
            }
            .frame(maxWidth: .infinity)
            
        }
    }
}

#Preview {
    ContentView()
}

