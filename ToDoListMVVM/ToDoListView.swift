//
//  ToDoListView.swift
//  ToDoListMVVM
//
//  Created by Merianni Nunez Tejeda on 12/9/24.
//

// Views/ToDoListView.swift
import SwiftUI

struct ToDoListView: View {
    @StateObject private var viewModel = ToDoViewModel()
    @State private var newToDoTitle: String = ""
    @State private var selectedToDo: ToDo? = nil

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new To-Do", text: $newToDoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 16)
                    Button(action: {
                        guard !newToDoTitle.isEmpty else { return }
                        viewModel.addToDo(title: newToDoTitle)
                        newToDoTitle = ""
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical, 8)

                List {
                    ForEach(viewModel.todos) { todo in
                        HStack {
                            Text(todo.title)
                                .strikethrough(todo.isCompleted, color: .yellow)
                                .foregroundColor(todo.isCompleted ? .gray : .black)
                            Spacer()
                            Button(action: {
                                viewModel.toggleCompletion(for: todo)
                            }) {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(todo.isCompleted ? .yellow : .gray)
                            }
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            selectedToDo = todo
                        }
                    }
                    .onDelete(perform: viewModel.removeToDo)
                }
                .sheet(item: $selectedToDo) { todo in
                    EditToDoView(todo: binding(for: todo))
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                EditButton()
                    .foregroundColor(.yellow)
            }
        }
    }

    private func binding(for todo: ToDo) -> Binding<ToDo> {
        guard let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) else {
            fatalError("To-Do not found")
        }
        return $viewModel.todos[index]
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
