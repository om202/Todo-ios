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
            ZStack {
                VStack {
                    Form {
                        Section {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(themeColor)
                                
                                HStack {
                                    TextField("I want to ...", text: $taskTitle)
                                        .focused($isTitleFocused)
                                }

                                if !taskTitle.isEmpty {
                                    Button {
                                        taskTitle = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(themeColor)
                                    }
                                }
                            }

                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundColor(themeColor)
                                HStack {
                                    TextField("Add a note", text: $taskNote)

                                    if !taskNote.isEmpty {
                                        Button {
                                            taskNote = ""
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(themeColor)
                                        }
                                    }
                                }
                            }
                        }

                        Section {
                            HStack {
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
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(themeColor) // Replaced .indigo with themeColor

                                Button {
                                    showTimePicker = true
                                } label: {
                                    HStack {
                                        Image(systemName: "clock")
                                        Text(
                                            selectedTime?.formatted(
                                                .dateTime.hour().minute()
                                            ) ?? "All day"
                                        )
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(themeColor) // Replaced .indigo with themeColor
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
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(themeColor) // Replaced .indigo with themeColor
                            }
                        }

                        Section {
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
                                    Image(systemName: "circle.fill")
                                    Text("Let's do it!")
                                }
                                .font(.headline)
                                .padding(8)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(themeColor) // Replaced .indigo with themeColor
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                    .bold()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Task")
                    }
                    .foregroundColor(themeColor)
                }
            }
        }
        .onAppear {
            isTitleFocused = true // Automatically focus the taskTitle TextField
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

