import Foundation
import SwiftUI

struct AcceptedQuestCard: View {
    var manager: QuestSlotManager
    
    var body: some View {
        if let acceptedQuest = manager.questSlot.acceptedQuest {
            VStack (spacing: 0) {
                HStack (spacing: 0){
                    VStack(alignment: .leading, spacing: 8) {
                        Text(acceptedQuest.reward.text)
                            .font(.title2)
                            .fontWeight(.bold)
                        HStack {
                            Text(manager.questSlot.quest.activatedDayOfWeeks.weeklyOccasionDescription())
                                .font(.callout)
                        }
                    }
                    Spacer()
                    PieChart(progress: acceptedQuest.taskCompletionRate, barThick: 7, graphSize: 60, fontSize: 20, percentSize: .caption2)
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 25)
                
#if DEBUG
                HStack {
                    Button(action: {
                        print(manager.questSlot.acceptedQuest!.acceptedTasks.count)
                        manager.questSlot.acceptedQuest!.acceptedTasks[0].isCompleted = true
                    }, label: {
                        Text("1つ完了させる")
                    })
                    Button(action: {
                        for task in acceptedQuest.acceptedTasks {
                            task.isCompleted = false
                        }
                    }, label: {
                        Text("リセット")
                    })
                    Button(action: {
                        manager.questSlot.acceptedQuest = nil
                    }, label: {
                        Text("諦める")
                    })
                    
                }
#endif
                
            }
            .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 15))
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    .fill(.gray.gradient)
            }
            .padding(.horizontal, 25)
        } else {
            Text("これが表示されているということは天変地異が起きたということです。")
        }

    }
}

#Preview {
    ContentView()
}
