import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @EnvironmentObject var taskStore: TaskStore

    @State private var taskTitle: String = ""
    @State private var taskNote: String = ""

    @State private var suggestions: [String] = []
    @State private var filteredSuggestions: [String] = []
    @State private var isSelectingSuggestion: Bool = false

    @State private var showDatePicker: Bool = false
    @State private var showTimePicker: Bool = false
    @State private var selectedTime: Date? = nil

    @State private var showDeadlinePicker: Bool = false
    @State private var selectedDeadline: Date? = nil

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            filteredSuggestions = []
                        }
                    }

                VStack {
                    Form {
                        Section {
                            HStack {
                                Image(systemName: "pencil.and.list.clipboard")
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    TextField("I want to ...", text: $taskTitle)
                                        .focused($isTitleFocused)
                                        .onChange(of: taskTitle) {oldValue, newValue in
                                            guard newValue.count > 2 else {
                                                filteredSuggestions = []
                                                return
                                            }
                                            if !isSelectingSuggestion {
                                                filteredSuggestions = suggestions.filter {
                                                    $0.lowercased()
                                                        .contains(newValue.lowercased())
                                                }
                                            }
                                        }

                                    if !taskTitle.isEmpty {
                                        Button {
                                            taskTitle = ""
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.indigo)
                                        }
                                    }
                                }
                            }

                            HStack {
                                Image(systemName: "scribble.variable")
                                    .foregroundColor(.gray)
                                HStack {
                                    TextField("Add a note", text: $taskNote)

                                    if !taskNote.isEmpty {
                                        Button {
                                            taskNote = ""
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.indigo)
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
                                    .foregroundColor(.gray)
                                }
                                .buttonStyle(.bordered)

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
                                    .foregroundColor(.gray)
                                }
                                .buttonStyle(.bordered)
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
                                    .foregroundColor(.gray)
                                }
                                .buttonStyle(.bordered)
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
                            }
                            label: {
                                HStack {
                                    Image(systemName: "circle.fill")
                                    Text("Let's do it!")
                                }
                                .font(.headline)
                                .padding(8)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.indigo)
                        }
                    }
                    .scrollContentBackground(.hidden)

                    // Only show overlay if we have suggestions AND the title field is focused
                    if !filteredSuggestions.isEmpty && isTitleFocused {
                        suggestionsOverlay
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
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
            loadSuggestions()
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

    private var suggestionsOverlay: some View {
        VStack {
            HStack {
                Text("Suggestions")
                Spacer()
                Button {
                    withAnimation {
                        filteredSuggestions = []
                    }
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .foregroundColor(.indigo)
            .padding(.vertical, 8)
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredSuggestions, id: \.self) { suggestion in
                        VStack {
                            Text(suggestion)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .onTapGesture {
                                    withAnimation {
                                        isSelectingSuggestion = true
                                        taskTitle = suggestion
                                        filteredSuggestions = []
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isSelectingSuggestion = false
                                        }
                                    }
                                }
                        }
                        Divider()
                    }
                }
            }
            .background(Color.clear)
        }
        .background(Color(.systemGray6))
        .frame(maxWidth: .infinity, alignment: .top)
        .transition(.opacity)
        .animation(.easeInOut, value: filteredSuggestions)
    }

    private func loadSuggestions() {
        if let url = Bundle.main.url(
            forResource: "TaskSuggestions",
            withExtension: "json"
        ),
        let data = try? Data(contentsOf: url),
        let decoded = try? JSONDecoder().decode([TaskSuggestion].self, from: data) {
            suggestions = decoded.map { $0.todo }
        }
    }
}

struct TaskSuggestion: Codable {
    let id: Int
    let todo: String
}
