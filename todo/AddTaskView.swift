//
//  AddTaskView.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var taskStore: TaskStore

    // :: Task Strings ::
    @State private var taskTitle: String = ""
    @State private var taskNote: String = ""
    // :: Date ::
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()
    // :: Time ::
    @State private var showTimePicker: Bool = false
    @State private var selectedTime: Date? = nil
    // :: DeadLine ::
    @State private var showDeadlinePicker: Bool = false
    @State private var selectedDeadline: Date? = nil
    // :: Keyboard Focus ::
    @FocusState private var showKeyboard: Bool

    func zeroOutSeconds(from date: Date?) -> Date? {
        guard let date = date else {
            return nil
        }
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                         from: date)
        components.second = 0
        return Calendar.current.date(from: components)
    }

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "pencil.and.list.clipboard")
                            .foregroundColor(.gray)
                        TextField("I want to ...", text: $taskTitle)
                            .focused($showKeyboard)
                    }

                    Spacer()

                    HStack {
                        Image(systemName: "scribble.variable")
                            .foregroundColor(.gray)
                        TextField("Add a note", text: $taskNote)
                    }

                    Spacer(minLength: 32)

                    HStack {

                        // Calendar - Choose Date
                        Button(action: {
                            showDatePicker = true
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                Text(
                                    selectedDate.formatted(
                                        date: .abbreviated, time: .omitted))
                            }
                            .foregroundColor(.gray)
                        }
                        .buttonStyle(.bordered)
                        .padding(.trailing)
                        .sheet(isPresented: $showDatePicker) {
                            NavigationView {
                                VStack(alignment: .center) {
                                    Label(
                                        "Select Date", systemImage: "calendar")
                                    DatePicker(
                                        "",
                                        selection: $selectedDate,
                                        in: Date()...,
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(.graphical)
                                    .padding()

                                    Spacer()
                                }
                                .navigationBarItems(
                                    trailing: Button("Done") {
                                        showDatePicker = false
                                    })
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }

                        // Clock - Choose Time
                        Button(action: {
                            showTimePicker = true
                        }) {
                            HStack {
                                Image(systemName: "clock")
                                Text(
                                    selectedTime?.formatted(
                                        .dateTime.hour().minute()) ?? "All day")
                            }
                            .foregroundColor(.gray)
                        }
                        .buttonStyle(.bordered)
                        .sheet(isPresented: $showTimePicker) {
                            NavigationView {
                                VStack(alignment: .center) {
                                    Label("Select Time", systemImage: "clock")
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: { selectedTime ?? Date() },
                                            set: { selectedTime = $0 }
                                        ),
                                        in: Date()...,
                                        displayedComponents: [.hourAndMinute]
                                    )
                                    .datePickerStyle(.wheel)
                                    .padding()
                                    .labelsHidden()

                                    Spacer()
                                }
                                .navigationBarItems(
                                    trailing: Button("Done") {
                                        showTimePicker = false
                                    })
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }

                    HStack {
                        // :: Deadline ::
                        if selectedTime != nil {
                            Button(action: {
                                showDeadlinePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "timer")
                                    Text(
                                        selectedDeadline != nil
                                            ? "Finish by \(selectedDeadline!.formatted(.dateTime.hour().minute()))"
                                            : "No Deadline")
                                }
                                .foregroundColor(.gray)
                            }
                            .buttonStyle(.bordered)
                            .sheet(isPresented: $showDeadlinePicker) {
                                NavigationView {
                                    VStack(alignment: .center) {
                                        Label(
                                            "Select a Deadline",
                                            systemImage: "timer")

                                        DatePicker(
                                            "Deadline",
                                            selection: Binding(
                                                get: {
                                                    selectedDeadline
                                                        ?? selectedTime!
                                                },
                                                set: { selectedDeadline = $0 }
                                            ),
                                            in: selectedTime!...,
                                            displayedComponents: [
                                                .hourAndMinute
                                            ]
                                        )
                                        .datePickerStyle(.wheel)
                                        .labelsHidden()
                                        .padding()

                                        Spacer()
                                    }
                                    .navigationBarItems(
                                        trailing: Button("Done") {
                                            showDeadlinePicker = false
                                        })
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                        }
                    }

                    Spacer(minLength: 32)

                    Button(
                        action: {
                            taskStore
                                .addTask(
                                    title: taskTitle,
                                    note: taskNote,
                                    date: zeroOutSeconds(from: selectedDate) ?? Date(),
                                    time: zeroOutSeconds(from: selectedTime),
                                    deadline: zeroOutSeconds(from: selectedDeadline)
                                )
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "circle.fill")
                                Text("Lets do it!")
                            }
                            .font(.headline)
                            .padding(4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.indigo)
                }
                .padding(.vertical)
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }.foregroundColor(Color.pink)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Task")
                    }
                }
            }
        }
        .onAppear {
            showKeyboard = true
        }
    }
}

#Preview {
    AddTaskView(taskStore: TaskStore())
}
