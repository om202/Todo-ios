import SwiftUI

struct MainView: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var editTask: Bool = false
    @State private var selectedDate: Date = Date()
    @State var useImageBG: Bool = true
    private var formattedDate: String {
        FormatDate(date: selectedDate)
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    List {
                        // Only proceed if there are tasks
                        if taskStore.tasks.count > 0 {
                            // 1) Filter tasks by selected date
                            let filteredTask = taskStore.tasks
                                .filter {
                                    Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
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
                                ForEach(filteredTask) { task in
                                    TaskSection(task: task)
                                }
                                .onDelete { indices in
                                    taskStore.deleteTask(at: indices)
                                }
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
                    .scrollContentBackground(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text(formattedDate)
                                .bold()
                                .font(.title)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button (action: {}) {
                                Image(systemName: "gear")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                            .buttonStyle(.automatic)
                            .foregroundColor(.primary)
                        }
                    }
                    .background(
                        useImageBG ?
                        AnyView(Image("bg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)) :
                        AnyView(LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.indigo]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    )
                }
                
                // Your date picker / footer
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
    MainView()
        .environmentObject(TaskStore())
        .environmentObject(GlobalTimeStore())
}
