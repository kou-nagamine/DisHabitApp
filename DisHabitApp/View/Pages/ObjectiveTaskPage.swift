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
                            let objective_nagamine = Objective(id: UUID(), text: "for:長峯")
                            let objective_kashi = Objective(id: UUID(), text: "for:柏原")
                            let objective_hirayama = Objective(id: UUID(), text: "for:平山")
                            let objective_yoshida = Objective(id: UUID(), text: "for:吉田")
                            
                            let tasks =  [
                                StandbyTask(id: UUID(), text: "英単語 5個", objective: objective_eng),
                                StandbyTask(id: UUID(), text: "腕立て 10回", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "腹筋 10回", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "懸垂 10回", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "微積分 3ページ", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "三角関数 3ページ", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "線形代数 3ページ", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "デスペ小テスト", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "基本情報5問", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "bono １時間", objective: objective_nagamine),
                                StandbyTask(id: UUID(), text: "AtCoder 過去問A", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "AtCoder 過去問B", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "論文サーベイ 30分", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "技術本 5ページ", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "バックランジ 10回", objective: objective_kashi),
                                StandbyTask(id: UUID(), text: "皿洗い", objective: objective_yoshida),
                                StandbyTask(id: UUID(), text: "部屋の掃除", objective: objective_yoshida),
                                StandbyTask(id: UUID(), text: "小説3ページ", objective: objective_yoshida),
                                StandbyTask(id: UUID(), text: "CLFトレーニング", objective: objective_yoshida),
                                StandbyTask(id: UUID(), text: "デスペ小テスト", objective: objective_yoshida),
                                StandbyTask(id: UUID(), text: "基本情報5問", objective: objective_yoshida),
                                StandbyTask(id: UUID(), text: "地域実習のロジックモデルに要素を付け加える", objective: objective_hirayama),
                                StandbyTask(id: UUID(), text: "基本情報1問", objective: objective_hirayama),
                            ]
                            
                            modelContext.insert(objective_eng)
                            modelContext.insert(objective_nagamine)
                            modelContext.insert(objective_kashi)
                            modelContext.insert(objective_hirayama)
                            modelContext.insert(objective_yoshida)
                            
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
