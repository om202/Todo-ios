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
                                    if task.time != nil {
                                        HStack {
                                            Spacer()
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
                                            .strikethrough(false)
                                        }
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    HStack {
                                        Image(
                                            systemName: task.isDone
                                                ? "checkmark.square.fill"
                                                : "square"
                                        )
                                        VStack {
                                            Text(task.title)
                                        }
                                    }

                                    if !task.note.trimmingCharacters(
                                        in: .whitespaces
                                    ).isEmpty {
                                        HStack {
                                            Text("Note")
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 3)
                                                .background(
                                                    Color.indigo.opacity(0.3)
                                                )
                                                .cornerRadius(2)
                                            Text(task.note)
                                        }
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                    }
                                }
                                .opacity(task.isDone ? 0.4 : 1)
                                .foregroundColor(
                                    task.isDone ? Color.green : Color.primary
                                )
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                withAnimation {
                                    taskStore.toggleTask(task)
                                }
                            }
                        }
                        .onDelete { indices in
                            withAnimation {
                                taskStore.deleteTask(at: indices)
                            }
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
                        Button(action: {
                            withAnimation {
                                editTask.toggle()
                            }
                        }) {
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
