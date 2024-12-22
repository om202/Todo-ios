//
//  ContentView.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var editTask: Bool = false
    var body: some View {
        NavigationView {
            List {
                ForEach(taskStore.tasks) { task in
                    HStack {
                        Image(
                            systemName: task.isDone
                                ? "checkmark.circle.fill" : "circle"
                        ) {
                            print("image")
                        }
                        Text(task.title)
                    }
                    .onTapGesture {
                        taskStore.toggleTask(task)
                        print("what is task in view \(task.isDone) \(task.title)")
                    }
                }
                .onDelete { indices in
                    taskStore.deleteTask(at: indices)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { editTask.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $editTask) {
                AddTaskView(taskStore: taskStore)
            }
        }
    }
}

#Preview {
    ContentView()
}
