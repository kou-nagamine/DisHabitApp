import Foundation

extension Dictionary where Value == Bool {
    func occasionCount() -> Int {
        return values.filter { $0 }.count
    }
    
    func weeklyOccasionDescription() -> String {
        let count = occasionCount()
        switch count {
        case 0:
            return "なし"
        case 1...6:
            return "週\(count)回"
        case 7:
            return "毎日"
        default:
            return "Invalid"
        }
    }
}
