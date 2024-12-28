import SwiftUI

struct AddTaskView: View {
    var themeColor: Color = .indigo

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @EnvironmentObject var taskStore: TaskStore

    @State private var taskTitle: String = ""
    @State private var taskNote: String = ""

    @State private var showDatePicker: Bool = false
    @State private var showTimePicker: Bool = false
    @State private var selectedTime: Date? = nil

    @State private var showDeadlinePicker: Bool = false
    @State private var selectedDeadline: Date? = nil

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header Section
                VStack(spacing: 8) {
                    Text("Create Your Task")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(themeColor)
                    Text("Plan your day by adding tasks below.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                // Task Title and Note Section
                VStack(spacing: 12) {
                    TextField("What do you want to accomplish?", text: $taskTitle)
                        .focused($isTitleFocused)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeColor.opacity(0.5), lineWidth: 1)
                        )

                    TextField("Add a note (optional)", text: $taskNote)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeColor.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                // Schedule Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Schedule")
                        .font(.headline)
                        .foregroundColor(themeColor)

                    VStack(spacing: 12) {
                        Button {
                            showDatePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                Text(
                                    taskDateStore.TaskDate.formatted(
                                        date: .abbreviated,
                                        time: .omitted
                                    )
                                )
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(themeColor.opacity(0.5), lineWidth: 1)
                            )
                            .foregroundColor(themeColor)
                        }

                        Button {
                            showTimePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "clock")
                                Text(
                                    selectedTime?.formatted(.dateTime.hour().minute()) ?? "All day"
                                )
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(themeColor.opacity(0.5), lineWidth: 1)
                            )
                            .foregroundColor(themeColor)
                        }

                        if selectedTime != nil {
                            Button {
                                showDeadlinePicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "timer")
                                    Text(
                                        selectedDeadline != nil
                                        ? "Finish by \(selectedDeadline!.formatted(.dateTime.hour().minute()))"
                                        : "No Deadline"
                                    )
                                    Spacer()
                                }
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(themeColor.opacity(0.5), lineWidth: 1)
                                )
                                .foregroundColor(themeColor)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Floating Action Button
                HStack {
                    Spacer()
                    Button {
                        taskStore.addTask(
                            title: taskTitle,
                            note: taskNote,
                            date: ZeroOutSeconds(from: taskDateStore.TaskDate) ?? Date(),
                            time: ZeroOutSeconds(from: selectedTime),
                            deadline: ZeroOutSeconds(from: selectedDeadline)
                        )
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            Text("Save Task")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(color: themeColor.opacity(0.4), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }
                        .foregroundColor(.pink)
                    }
                }
            }
            .onAppear {
                isTitleFocused = true
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationView {
                VStack {
                    Label("Select Date", systemImage: "calendar")
                    DatePicker(
                        "Select Date",
                        selection: Binding(
                            get: { taskDateStore.TaskDate },
                            set: { taskDateStore.TaskDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    
                    Spacer()
                }
                .navigationBarItems(
                    trailing: Button("Done") {
                        showDatePicker = false
                    }
                )
            }
        }
        .sheet(isPresented: $showTimePicker) {
            NavigationView {
                VStack {
                    Label("Select Task Time", systemImage: "timer")
                    DatePicker(
                        "Select Time",
                        selection: Binding(
                            get: { selectedTime ?? Date() },
                            set: { selectedTime = $0 }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .padding()
                    .labelsHidden()
                    
                    Spacer()
                }
                .navigationBarItems(
                    trailing: Button("Done") {
                        showTimePicker = false
                    }
                )
            }
        }
        .sheet(isPresented: $showDeadlinePicker) {
            NavigationView {
                VStack {
                    Label("Select Task Deadline", systemImage: "timer")
                    DatePicker(
                        "Select Deadline",
                        selection: Binding(
                            get: { selectedDeadline ?? (selectedTime ?? Date()) },
                            set: { selectedDeadline = $0 }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .padding()
                    .labelsHidden()
                    
                    Spacer()
                }
                .navigationBarItems(
                    trailing: Button("Done") {
                        showDeadlinePicker = false
                    }
                )
            }
        }
    }
}
