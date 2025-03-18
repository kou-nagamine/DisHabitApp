//import Foundation
//
//class Objective: Identifiable {
//    var id: UUID
//    var text: String
//
//    init(id: UUID, text: String) {
//        self.id = id
//        self.text = text
//    }
//}
//
//class Task: Identifiable {
//    var id: UUID
//    var text: String
//    var objective: Objective?
//
//    init(id: UUID, text: String, objective: Objective?) {
//        self.id = id
//        self.text = text
//        self.objective = objective
//    }
//}
//
//// 受注済みタスク定義
//struct AcceptedTask: Identifiable {
//    var originalTask: Task
//    var isCompleted: Bool = false
//    
//    // 元のTaskのプロパティにアクセスするための転送プロパティ
//    var id: UUID { originalTask.id }
//    var text: String { originalTask.text }
//    var objective: Objective? { originalTask.objective }
//    
//    // 完了状態を変更した新しいインスタンスを返す
//    func markAsCompleted() -> AcceptedTask {
//        var updated = self
//        updated.isCompleted = true
//        return updated
//    }
//}
