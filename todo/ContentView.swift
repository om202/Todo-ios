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
            ZStack {
                // Main Content: Task List
                List {
                    if taskStore.tasks.count > 0 {
                        ForEach(taskStore.tasks) { task in
                            HStack {
                                Image(
                                    systemName: task.isDone
                                        ? "checkmark.circle.fill" : "circle"
                                )
                                Text(task.title)
                                    .strikethrough(task.isDone)
                            }
                            .padding(8)
                            .foregroundColor(
                                task.isDone
                                    ? Color.primary.opacity(0.5) : Color.primary
                            )
                            .onTapGesture {
                                taskStore.toggleTask(task)
                            }
                        }
                        .onDelete { indices in
                            taskStore.deleteTask(at: indices)
                        }
                    } else {
                        VStack {
                            Image(systemName: "cat")
                                .font(.largeTitle)
                                .padding(.bottom, 8)
                            Text("Nothing here!")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                    }
                }
                .navigationTitle("Tasks")

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { editTask.toggle() }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding(24)
                                .background(Color.indigo)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
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
