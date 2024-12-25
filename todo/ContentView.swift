import SwiftUI

struct ContentView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var editTask: Bool = false
    @State private var selectedDate: Date = Date()
    let dateFormatter = DateFormatter()

    var formattedDate: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(selectedDate) {
            return "Yesterday"
        } else {
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: selectedDate)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    List {
                        if taskStore.tasks.count > 0 {
                            let filteredTask = taskStore.tasks.filter {
                                Calendar.current.isDate(
                                    $0.date, inSameDayAs: selectedDate)
                            }

                            if filteredTask.isEmpty {
                                HStack {
                                    Image(systemName: "tray")
                                    Text("No Tasks")
                                }
                                .padding()
                                .font(.title3)
                                .foregroundColor(.gray)
                            } else {
                                ForEach(
                                    filteredTask
                                ) { task in
                                    TaskSection(task: task)                                }
                                .onDelete { indices in
                                    withAnimation {
                                        taskStore.deleteTask(at: indices)
                                    }
                                }
                                .listSectionSpacing(16)
                            }
                        } else {
                            VStack {
                                Image(systemName: "cat")
                                    .font(.largeTitle)
                                    .padding(.bottom, 8)
                                Text("Use the + button to add tasks.")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("\(formattedDate)").bold().font(.title)
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            Image("user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.gray.opacity(0.3),
                                            lineWidth: 1)
                                )
                        }
                    }
                }
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)

                TaskMainFooter(
                    selectedDate: $selectedDate,
                    editTask: $editTask,
                    formattedDate: formattedDate
                )

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
