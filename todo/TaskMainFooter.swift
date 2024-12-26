import SwiftUI

struct TaskMainFooter: View {
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @Binding var editTask: Bool
    @State private var isCalendarPresented: Bool = false
    let vibMed = UIImpactFeedbackGenerator(style: .medium)
    var formattedDate: String

    func addDays(_ days: Int) {
        if let newDate = Calendar.current.date(
            byAdding: .day, value: days, to: taskDateStore.TaskDate
        ) {
            taskDateStore.TaskDate = newDate
            vibMed.impactOccurred()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Date Navigation Controls
                HStack {
                    Button(action: { addDays(-1) }) {
                        Image(systemName: "arrow.left")
                    }
                    .buttonStyle(.borderless)
                    .padding(.trailing, 8)
                    .font(.title2)
                    .foregroundColor(.gray)

                    // Tap to open calendar
                    Button("\(formattedDate)") {
                        isCalendarPresented = true  // Show calendar
                    }
                    .buttonStyle(.plain)

                    Button(action: { addDays(1) }) {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.borderless)
                    .padding(.leading, 8)
                    .font(.title2)
                    .foregroundColor(.gray)
                }

                Spacer()

                // Add Task Button
                Button(action: {
                    withAnimation {
                        editTask.toggle()
                    }
                }) {
                    Label {
                        Text("Add Task")
                            .padding(.leading, 8)
                    } icon: {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.indigo)
                }.buttonStyle(.plain)
            }
            .foregroundColor(.primary)
            .padding()
            .bold()
        }
        // Calendar Modal
        .sheet(isPresented: $isCalendarPresented) {
            NavigationView {
                VStack {
                    Label("Select Date", systemImage: "calendar")

                    DatePicker(
                        "Select Date",
                        selection: $taskDateStore.TaskDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .padding(.horizontal)
                    .accentColor(.indigo)

                    Spacer()
                }
                .navigationBarItems(
                    trailing: Button("Done") {
                        isCalendarPresented = false
                    })
            }
        }
    }
}
