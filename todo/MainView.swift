import SwiftUI

struct MainView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @State var useImageBG: Bool = true
    
    private var formattedDate: String {
        FormatDate(date: taskDateStore.TaskDate)
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    List {
                        if taskStore.tasks.isEmpty {
                            NoTasksView(currentDate: taskDateStore.TaskDate)
                        } else {
                            let filteredTasks = taskStore.tasks.filter {
                                Calendar.current.isDate($0.date, inSameDayAs: taskDateStore.TaskDate)
                            }

                            if filteredTasks.isEmpty {
                                NoTasksView(currentDate: taskDateStore.TaskDate)
                            } else {
                                ForEach(filteredTasks) { task in
                                    TaskSection(task: task)
                                }
                                .onDelete { indices in
                                    taskStore.deleteTask(at: indices)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(
                        Group {
                            if useImageBG {
                                Image("bg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .indigo]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                        }
                        .edgesIgnoringSafeArea(.all) // Apply to both options
                    )
                    // Use .navigationBarLeading / .navigationBarTrailing for iOS 16 or earlier
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text(formattedDate)
                                .bold()
                                .font(.title)
                                .foregroundColor(.primary)
                                .shadow(
                                    color: Color.white.opacity(0.1),
                                    radius: 1,
                                    x: 1,
                                    y: 1
                                )
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {}) {
                                Image(systemName: "gear")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                            .buttonStyle(.automatic)
                            .foregroundColor(.primary)
                            .shadow(
                                color: Color.white.opacity(0.1),
                                radius: 1,
                                x: 1,
                                y: 1
                            )
                        }
                    }
                }
                
                TaskMainFooter(
                    formattedDate: formattedDate
                )
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(TaskStore())
        .environmentObject(GlobalTimeStore())
        .environmentObject(GlobalTaskDateStore())
}
