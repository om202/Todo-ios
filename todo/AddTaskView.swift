import SwiftUI

// Enum to manage focusable fields
enum FocusableField: Hashable {
    case title
    case note
}

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

    @FocusState private var focusedField: FocusableField?

    var body: some View {
        NavigationView {
            ZStack {
                // Detect taps outside to dismiss keyboard
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }

                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 8) {
                            Text("Create Your Task")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(themeColor)
                            Text("Plan your day by adding tasks below.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)

                        // Task Title and Note Section
                        VStack(spacing: 16) {
                            // Task Title Input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Task Title")
                                    .font(.headline)
                                    .foregroundColor(themeColor)
                                TextField("What do you want to accomplish?", text: $taskTitle)
                                    .padding()
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(themeColor.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .title)
                            }

                            // Task Note Input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .font(.headline)
                                    .foregroundColor(themeColor)
                                TextField("Add a note (optional)", text: $taskNote)
                                    .padding()
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(themeColor.opacity(0.3), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .note)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Schedule Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Schedule")
                                .font(.headline)
                                .foregroundColor(themeColor)
                                .padding(.horizontal, 20)

                            VStack(spacing: 16) {
                                // Date Picker Button
                                Button(action: {
                                    focusedField = nil
                                    showDatePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(themeColor)
                                        VStack(alignment: .leading) {
                                            Text("Date")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text(taskDateStore.TaskDate, style: .date)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                }

                                // Time Picker Button
                                Button(action: {
                                    focusedField = nil
                                    showTimePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(themeColor)
                                        VStack(alignment: .leading) {
                                            Text("Time")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text(selectedTime?.formatted(.dateTime.hour().minute()) ?? "All day")
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                }

                                // Deadline Picker Button (Visible only if Time is selected)
                                if selectedTime != nil {
                                    Button(action: {
                                        focusedField = nil
                                        showDeadlinePicker = true
                                    }) {
                                        HStack {
                                            Image(systemName: "timer")
                                                .foregroundColor(themeColor)
                                            VStack(alignment: .leading) {
                                                Text("Deadline")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Text(selectedDeadline != nil ? "Finish by \(selectedDeadline!.formatted(.dateTime.hour().minute()))" : "No Deadline")
                                                    .font(.body)
                                                    .foregroundColor(.primary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        Spacer()

                        // Save Task Button
                        Button(action: {
                            focusedField = nil
                            taskStore.addTask(
                                title: taskTitle,
                                note: taskNote,
                                date: ZeroOutSeconds(from: taskDateStore.TaskDate) ?? Date(),
                                time: ZeroOutSeconds(from: selectedTime),
                                deadline: ZeroOutSeconds(from: selectedDeadline)
                            )
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.headline)
                                Text("Save Task")
                                    .fontWeight(.bold)
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [themeColor, themeColor.opacity(0.7)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: themeColor.opacity(0.4), radius: 5, x: 0, y: 3)
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemGray6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        focusedField = nil
                        dismiss()
                    }) {
                        HStack {
                            Text("Cancel")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.indigo)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        focusedField = nil
                        taskStore.addTask(
                            title: taskTitle,
                            note: taskNote,
                            date: ZeroOutSeconds(from: taskDateStore.TaskDate) ?? Date(),
                            time: ZeroOutSeconds(from: selectedTime),
                            deadline: ZeroOutSeconds(from: selectedDeadline)
                        )
                        dismiss()
                    }) {
                        HStack {
                            Text("Done")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.indigo)
                    }
                }
            }
            .onAppear {
                // Automatically focus on the title field when the view appears
                focusedField = .title
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationView {
                VStack {
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
