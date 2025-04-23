//import Foundation
//import SwiftData
//
//@Model
//class Objective: Identifiable {
//    var id: UUID
//    var text: String
//
//    init(id: UUID = UUID(), text: String) {
//        self.id = id
//        self.text = text
//    }
//    
//    func copyValues(from source: Objective) {
//        self.id = source.id
//        self.text = source.text
//    }
//    
//    func deepCopy() -> Objective {
//        return Objective(id: self.id, text: self.text)
//    }
//}
//
//@Model
//class StandbyTask: Identifiable {
//    var id: UUID
//    var text: String
//    @Relationship var objective: Objective?
//
//    init(id: UUID = UUID(), text: String, objective: Objective? = nil) {
//        self.id = id
//        self.text = text
//        self.objective = objective
//    }
//    
//    func copyValues(from source: StandbyTask) {
//        self.id = source.id
//        self.text = source.text
//        self.objective = source.objective
//    }
//    
//    func deepCopy() -> StandbyTask {
//        return StandbyTask(id: self.id, text: self.text, objective: self.objective)
//    }
//}
//
//// 受注済みタスク定義
//@Model
//class AcceptedTask: Identifiable {
//    var id: UUID = UUID()
//    @Relationship var originalTask: StandbyTask
//    var isCompleted: Bool = false
//    
//    init(originalTask: StandbyTask, isCompleted: Bool = false) {
//        self.originalTask = originalTask
//        self.isCompleted = isCompleted
//    }
//    
//    // 元のTaskのプロパティにアクセスするためのメソッド
//    var text: String { originalTask.text }
//    var objective: Objective? { originalTask.objective }
//    
//    // 完了状態を変更した新しいインスタンスを返す
//    func markAsCompleted() -> AcceptedTask {
//        let updated = AcceptedTask(originalTask: self.originalTask)
//        updated.isCompleted = true
//        return updated
//    }
//    
//    func toggleValue() {
//        isCompleted = !isCompleted
//    }
//}
