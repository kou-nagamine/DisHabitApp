import SwiftUI
import SwiftData

struct ObjectiveTaskPage: View {
    
    @Query var objectives: [Objective]
    @Query var tasks: [StandbyTask]
    
    var commonObjectives: [Objective] { objectives.filter { $0.text.contains("for:") } }
    var indivisualObjectives: [Objective] { objectives.filter { !$0.text.contains("for:") } }
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 10) {
            Text("タスク一覧")
                .font(.largeTitle)
                .padding(.vertical, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    ForEach(indivisualObjectives) { objective in
                        Text(objective.text)
                            .font(.title2)
                            .padding(.leading, 30)
                        ForEach(tasks) { task in
                            if let taskobj = task.objective {
                                if taskobj.id == objective.id {
                                    CheckBoxList(isSelected: false, taskName: task.text, isReadonly: true, isLabelOnly: true, checkedStyle: .select,
                                        toggleAction: {})
                                }
                            }
                        }
                    }
                    ForEach(commonObjectives) { objective in
                        Text(objective.text)
                            .font(.title2)
                            .padding(.leading, 30)
                        ForEach(tasks) { task in
                            if let taskobj = task.objective {
                                if taskobj.id == objective.id {
                                    CheckBoxList(isSelected: false, taskName: task.text, isReadonly: true, isLabelOnly: true, checkedStyle: .select,
                                        toggleAction: {})
                                }
                            }
                        }
                    }
                    
                    if tasks.isEmpty {
                        Button(action: {
                            let objective_nagamine = Objective(id: UUID(), text: "for:長峯")
                            let objective_hirayama = Objective(id: UUID(), text: "for:平山")
//                            let objective_sekine = Objective(id: UUID(), text: "for:関根")
                            
                            let tasks =  [
                                StandbyTask(id: UUID(), text: "bono １時間", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "Swift文法　30分", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "SwiftUI　30分", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "統計　1章", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "基本情報1問", objective: objective_hirayama),
                                StandbyTask(id: UUID(), text: "日記を書く", objective: objective_hirayama),
                                StandbyTask(id: UUID(), text: "英単語5個", objective: objective_hirayama),
                            ]
                            
                            modelContext.insert(objective_nagamine)
                            modelContext.insert(objective_hirayama)
//                            modelContext.insert(objective_sekine)
                            
                            for t in tasks {
                                modelContext.insert(t)
                            }
                            
                        }, label: { Text("目標/タスク初期化") })
                    }
                }
            }
        }
    }
}


#Preview {
    ObjectiveTaskPage()
}
