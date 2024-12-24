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
    let dateFormatter = DateFormatter()

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if taskStore.tasks.count > 0 {
                        ForEach(taskStore.tasks) { task in
                            Section {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image(
                                            systemName: task.isDone
                                                ? "checkmark.circle.fill"
                                                : "circle"
                                        )
                                        VStack {
                                            Text(task.title)
                                                .strikethrough(task.isDone)
                                        }
                                    }

                                    if !task.note.trimmingCharacters(
                                        in: .whitespaces
                                    ).isEmpty {
                                        HStack {
                                            VStack {
                                                Text(task.note)
                                                    .strikethrough(task.isDone)
                                                    .font(.subheadline)
                                                    .foregroundColor(
                                                        task.isDone
                                                            ? Color.primary
                                                                .opacity(0.4)
                                                            : .purple
                                                    )
                                            }
                                        }
                                    }

                                    HStack {
                                        Spacer()
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(
                                                task.date.formatted(
                                                    .dateTime.month(
                                                        .abbreviated
                                                    )
                                                    .day())
                                            )
                                        }
                                        if task.time != nil {
                                            HStack {
                                                Image(systemName: "clock")
                                                Text(
                                                    task.time?
                                                        .formatted(
                                                            .dateTime
                                                                .hour()
                                                                .minute()
                                                        ) ?? ""
                                                )
                                            }
                                        }
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(
                                        task.isDone
                                            ? Color.primary.opacity(0.4)
                                            : .purple
                                    )
                                }
                                .foregroundColor(
                                    task.isDone
                                        ? Color.primary.opacity(0.4)
                                        : Color.primary
                                )
                                .onTapGesture {
                                    taskStore.toggleTask(task)
                                }
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
                .listSectionSpacing(20)

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
            .navigationTitle("Hello")
        }
    }
}

#Preview {
    ContentView()
}
