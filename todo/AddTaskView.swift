//
//  AddTaskView.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var taskStore: TaskStore
    @State private var newTask: String = ""
    var body: some View {
        NavigationView {
            Form {
                TextField("Task", text: $newTask)
                Button(action: {
                    taskStore.addTask(title: newTask)
                    dismiss()
                }) {
                    Text("Add Task").frame(maxWidth: .infinity)
                }
                .buttonStyle(.automatic)
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
