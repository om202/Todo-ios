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
                        if taskStore.tasks.count > 0 {
                            let filteredTask = taskStore.tasks
                                .filter {
                                    Calendar.current.isDate($0.date, inSameDayAs: taskDateStore.TaskDate)
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
                    .background(
                        useImageBG
                            ? AnyView(
                                Image("bg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                              )
                            : AnyView(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .indigo]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                              )
                    )
                    // Use .navigationBarLeading / .navigationBarTrailing for iOS 16 or earlier
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text(formattedDate)
                                .bold()
                                .font(.title)
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
