import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var filterindex=0
    
    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
        self.toDoItemsWork = clone(todoItemsOriginal: toDoItems)
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = []
    
    var toDoItemsWork: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItemsWork)
        }
    }

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
        toDoItemsWork.append(item.copy())
        if (filterindex == 1) {
            applyFilter(at: filterindex)
        }
    }
    
    /// Toggles the completion status of a to-do per array
    /// - Parameters:
    ///   - itemToModify: TodoItem to modify
    ///   - items: TodoItems Array
    private func toggleTodoItemCompletionByArray(itemToModify: ToDoItem, items: inout Array<ToDoItem>) {
        if let index = items.firstIndex(where: { $0.id == itemToModify.id }) {
            items[index].isDone.toggle()
        }
        
    }
    
    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        toggleTodoItemCompletionByArray(itemToModify: item, items: &toDoItems)
        toggleTodoItemCompletionByArray(itemToModify: item, items: &toDoItemsWork)
        applyFilter(at: filterindex)
    
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
        toDoItemsWork.removeAll { $0.id == item.id }
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        
        self.toDoItems = repository.loadToDoItems()
        self.toDoItemsWork =  clone(todoItemsOriginal: self.toDoItems)
        switch index {
        case 1:
            toDoItems.removeAll(where: {!$0.isDone})
        case 2:
            toDoItems.removeAll(where: {$0.isDone})
        default:
           break
        }
        filterindex=index
       
    }
    
    /// Clone TodoItems array
    /// - Parameter todoItems: TodoItems Array
    /// - Returns: clone of TodoItems
    func clone(todoItemsOriginal todoItems: Array<ToDoItem>) -> Array<ToDoItem> {
        var toDoItemsClone: [ToDoItem] = []
        for element in todoItems {
            toDoItemsClone.append(element.copy())
        }
        return toDoItemsClone
    }
    
}

