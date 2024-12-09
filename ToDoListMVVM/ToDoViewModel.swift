//
//  ToDoViewModel.swift
//  ToDoListMVVM
//
//  Created by Merianni Nunez Tejeda on 12/9/24.
//

// ViewModels/ToDoViewModel.swift
import Foundation

class ToDoViewModel: ObservableObject {
    @Published var todos: [ToDo] = []

    // Initialize with some sample data
    init() {
        loadSampleData()
    }

    func loadSampleData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.todos = [
                ToDo(title: "Buy groceries"),
                ToDo(title: "Walk the dog"),
                ToDo(title: "Read a book")
            ]
        }
    }
    func addToDo(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        let newToDo = ToDo(title: trimmedTitle)
        todos.append(newToDo)
    }

    func toggleCompletion(for todo: ToDo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }

    func removeToDo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}
