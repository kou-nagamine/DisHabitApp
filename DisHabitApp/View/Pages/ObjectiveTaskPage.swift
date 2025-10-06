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
                            let objective_sotuken_english = Objective(id: UUID(), text: "英語")
                            
                            let tasks =  [
                                StandbyTask(id: UUID(), text: "英文 3 Sentences", objective: objective_sotuken_english),
                                StandbyTask(id: UUID(), text: "英文 5 Sentences", objective: objective_sotuken_english),
                                StandbyTask(id: UUID(), text: "英文 10 Sentences", objective: objective_sotuken_english),
                                StandbyTask(id: UUID(), text: "英文 15 Sentences", objective: objective_sotuken_english),
                                StandbyTask(id: UUID(), text: "英文 20 Sentences", objective: objective_sotuken_english),
                            ]
                            
                            modelContext.insert(objective_sotuken_english)
                            
                            for t in tasks {
                                modelContext.insert(t)
                            }
                            
                        }, label: { Text("アプリの使用を開始する") })
                    }
                }
            }
        }
    }
}


#Preview {
    ObjectiveTaskPage()
}
