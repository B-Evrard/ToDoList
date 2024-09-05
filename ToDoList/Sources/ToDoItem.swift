import Foundation

struct ToDoItem: Equatable, Codable, Identifiable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
    
    func copy(title: String? = nil, isDone: Bool? = nil) -> ToDoItem {
        .init( id: id.self,
            title: title ?? self.title,
               isDone: isDone ?? self.isDone
        )
    }
}
