import SwiftUI

struct TaskMainFooter: View {
    var themeColor: Color = .indigo
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @State private var isCalendarPresented: Bool = false
    @State private var editTask: Bool = false
    var formattedDate: String

    func addDays(_ days: Int) {
        if let newDate = Calendar.current.date(
            byAdding: .day, value: days, to: taskDateStore.TaskDate
        ) {
            taskDateStore.TaskDate = newDate
            HapticsManager.mediumImpact()
        }
    }

    var body: some View {
        HStack {
            // Date Navigation
            Button(action: { addDays(-1) }) {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.title)
                    .foregroundColor(themeColor)
            }

            Spacer().frame(width: 16)

            // Current Date Button
            Button(action: {
                isCalendarPresented = true
            }) {
                Text(formattedDate)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(themeColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(width: 125) // Sets the button's width to 200 points
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themeColor.opacity(0.5), lineWidth: 1)
                    )
            }
            
            Spacer().frame(width: 16)

            // Date Navigation
            Button(action: { addDays(1) }) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title)
                    .foregroundColor(themeColor)
            }

            Spacer()

            // Add Task Button
            Button(action: {
                withAnimation {
                    editTask.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Task")
                }
                .font(.title3)
                .foregroundColor(themeColor)
            }
            .shadow(
                color: themeColor.opacity(0.5),
                radius: 10,
                x: 0,
                y: 4
            )
        }

        .padding(.horizontal)
        .padding(.bottom, 8)
        .sheet(isPresented: $editTask) {
            AddTaskView()
        }
        .sheet(isPresented: $isCalendarPresented) {
            NavigationView {
                VStack {
                    Label("Select Date", systemImage: "calendar")
                        .font(.headline)
                        .foregroundColor(themeColor)

                    DatePicker(
                        "Select Date",
                        selection: $taskDateStore.TaskDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .accentColor(themeColor)

                    Spacer()
                }
                .navigationBarItems(
                    trailing: Button("Done") {
                        isCalendarPresented = false
                    }
                    .foregroundColor(themeColor)
                )
            }
        }
    }
}
