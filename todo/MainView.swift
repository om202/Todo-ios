import SwiftUI

struct MainView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @State var useImageBG: Bool = true
    @State var selectedBGImage: String = "bg5"
    @State private var selectedGradient: GradientOption? = nil
    @State private var showSettingsSheet: Bool = false
    
    private var formattedDate: String {
        FormatDate(date: taskDateStore.TaskDate)
    }

    var body: some View {
        NavigationView {
            VStack {
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
                        if useImageBG, !selectedBGImage.isEmpty {
                            Image(selectedBGImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if let gradient = selectedGradient?.gradient {
                            LinearGradient(
                                gradient: gradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        } else {
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .indigo]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(formattedDate)
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: 1)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSettingsSheet.toggle()
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: 1)
                        }
                    }
                }

                TaskMainFooter(
                    formattedDate: formattedDate
                )
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsSheet(
                    selectedBGImage: $selectedBGImage,
                    selectedGradient: $selectedGradient,
                    useImageBG: $useImageBG
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
