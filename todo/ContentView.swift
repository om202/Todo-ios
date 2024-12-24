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
                                                ? "checkmark.square.fill"
                                                : "square"
                                        )
                                        VStack {
                                            Text(task.title)
                                                .strikethrough(task.isDone)
                                        }
                                    }

                                    if !task.isDone {
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
                                        .foregroundColor(.gray)
                                    }
                                }
                                .foregroundColor(
                                    task.isDone
                                        ? Color.primary.opacity(0.3)
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
                        .listSectionSpacing(16)

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
                .navigationTitle("My Tasks")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            // action here
                        }) {
                            Image(systemName: "line.3.horizontal")
                        }
                        .buttonStyle(.borderless)
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button(action: {
                                // action here
                            }) {
                                Image(systemName: "chevron.left")
                            }

                            Button("Today") {
                            }.buttonStyle(.borderless).bold()

                            Button(action: {
                                // action here
                            }) {
                                Image(systemName: "chevron.right")
                            }
                            .buttonStyle(.borderless)
                        }.foregroundColor(Color.primary)
                    }
                }

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
