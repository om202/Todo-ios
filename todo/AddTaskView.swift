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

    @State private var newTask: String = ""
    // date
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()
    // time
    @State private var showTimePicker: Bool = false
    @State private var selectedTime: Date? = nil

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    TextField("I want to ...", text: $newTask)

                    Spacer()

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
                                    Label("Select Date", systemImage: "calendar")
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
                                Text(selectedTime?.formatted(.dateTime.hour().minute()) ?? "All day")
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
                                .navigationBarItems(trailing: Button("Done") {
                                    showTimePicker = false
                                })
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }

                    Spacer(minLength: 32)

                    Button(action: {
                        taskStore.addTask(title: newTask)
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
    }
}

#Preview {
    AddTaskView(taskStore: TaskStore())
}
