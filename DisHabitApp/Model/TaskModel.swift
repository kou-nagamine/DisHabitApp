import Foundation

class Objective: Identifiable {
    var id: UUID
    var text: String

    init(id: UUID, text: String) {
        self.id = id
        self.text = text
    }
    
    func copyValues(from source: Objective) {
        self.id = source.id
        self.text = source.text
    }
    
    func deepCopy() -> Objective {
        return Objective(id: self.id, text: self.text)
    }
}

class Task: Identifiable {
    var id: UUID
    var text: String
    var objective: Objective?

    init(id: UUID, text: String, objective: Objective?) {
        self.id = id
        self.text = text
        self.objective = objective
    }
    
    func copyValues(from source: Task) {
        self.id = source.id
        self.text = source.text
        self.objective = source.objective
    }
    
    func deepCopy() -> Task {
        return Task(id: self.id, text: self.text, objective: self.objective)
    }
}

// 受注済みタスク定義
struct AcceptedTask: Identifiable {
    var originalTask: Task
    var isCompleted: Bool = false
    
    // 元のTaskのプロパティにアクセスするための転送プロパティ
    var id: UUID { originalTask.id }
    var text: String { originalTask.text }
    var objective: Objective? { originalTask.objective }
    
    // 完了状態を変更した新しいインスタンスを返す
    func markAsCompleted() -> AcceptedTask {
        var updated = self
        updated.isCompleted = true
        return updated
    }
}
