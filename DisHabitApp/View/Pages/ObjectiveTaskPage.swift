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
                            let objective_eng = Objective(id: UUID(), text: "TOEIC700点")
                            let objective_well = Objective(id: UUID(), text: "健康維持")
                            let objective_ipa = Objective(id: UUID(), text: "応用情報合格")
                            let objective_nagamine = Objective(id: UUID(), text: "for:長峯")
                            let objective_kashi = Objective(id: UUID(), text: "for:柏原")
                            
                            let tasks =  [
                                StandbyTask(id: UUID(), text: "英単語 5個", objective: objective_eng),
                                StandbyTask(id: UUID(), text: "腕立て 10回", objective: objective_well),
                                StandbyTask(id: UUID(), text: "腹筋 10回", objective: objective_well),
                                StandbyTask(id: UUID(), text: "懸垂 10回", objective: objective_well),
                                StandbyTask(id: UUID(), text: "バックランジ 10回", objective: objective_well),
                                StandbyTask(id: UUID(), text: "応用情報ドットコム 1問", objective: objective_ipa),
                                StandbyTask(id: UUID(), text: "データベース", objective: objective_ipa),
                                StandbyTask(id: UUID(), text: "微積分 3ページ", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "三角関数 3ページ", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "線形代数 3ページ", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "確率 1講座", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "AtCoder 過去問A", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "AtCoder 過去問B", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "論文サーベイ 30分", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "技術本 5ページ", objective: objective_kashi),
                            ]
                            
                            modelContext.insert(objective_eng)
                            modelContext.insert(objective_well)
                            modelContext.insert(objective_ipa)
                            modelContext.insert(objective_nagamine)
                            modelContext.insert(objective_kashi)
                            
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
