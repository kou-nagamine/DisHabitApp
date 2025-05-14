import SwiftUI
import SwiftData

struct ObjectiveTaskPage: View {
    
    @Query var objectives: [Objective]
    @Query var tasks: [StandbyTask]
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 10) {
            Text("タスク一覧")
                .font(.largeTitle)
                .padding(.vertical, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if tasks.isEmpty {
                        Button(action: {
                            let objective1 = Objective(id: UUID(), text: "健康的な生活を送る")
                            let objective2 = Objective(id: UUID(), text: "勉強習慣を身につける")
                            let objective3 = Objective(id: UUID(), text: "運動を習慣化する")

                            let task1 = StandbyTask(id: UUID(), text: "朝7時に起床する", objective: objective1)
                            let task2 = StandbyTask(id: UUID(), text: "朝食を食べる", objective: objective1)
                            let task3 = StandbyTask(id: UUID(), text: "1時間勉強する", objective: objective2)
                            let task4 = StandbyTask(id: UUID(), text: "30分ジョギングする", objective: objective3)
                            let task5 = StandbyTask(id: UUID(), text: "ストレッチをする", objective: objective3)
                            
                            modelContext.insert(objective1)
                            modelContext.insert(objective2)
                            modelContext.insert(objective3)
                            modelContext.insert(task1)
                            modelContext.insert(task2)
                            modelContext.insert(task3)
                            modelContext.insert(task4)
                            modelContext.insert(task5)
                            
                        }, label: { Text("目標/タスク初期化") })
                    }
                    ForEach(objectives) { objective in
                        Text(objective.text)
                            .font(.title2)
                            .padding(.leading, 30)
                        ForEach(tasks) { task in
                            /// checkedはselectedTasks.contains()で判定する
                            /// toggleActionでappend/removeする
                            if let taskobj = task.objective {
                                if taskobj.id == objective.id {
                                    CheckBoxList(isSelected: false, taskName: task.text, isReadonly: true, isLabelOnly: true, checkedStyle: .select,
                                        toggleAction: {})
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}


#Preview {
    ObjectiveTaskPage()
}
