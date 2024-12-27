import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskDateStore: GlobalTaskDateStore
    @EnvironmentObject var taskStore: TaskStore

    // :: Task Strings ::
    @State private var taskTitle: String = ""
    @State private var taskNote: String = ""
    @State private var suggestions: [String] = []
    @State private var filteredSuggestions: [String] = []
    @State private var isSelecting: Bool = false  // New state to handle selection

    // :: Date ::
    @State private var showDatePicker: Bool = false
    // :: Time ::
    @State private var showTimePicker: Bool = false
    @State private var selectedTime: Date? = nil
    // :: DeadLine ::
    @State private var showDeadlinePicker: Bool = false
    @State private var selectedDeadline: Date? = nil
    // :: Keyboard Focus ::
    @FocusState private var showKeyboard: Bool

    var body: some View {
        NavigationView {
            ZStack {
                // Background tap to dismiss suggestions
                Color.clear
                    .contentShape(Rectangle()) // Makes the entire area tappable
                    .onTapGesture {
                        withAnimation {
                            filteredSuggestions = [] // Clear suggestions on outside tap
                        }
                    }

                VStack {
                    // Main Form
                    Form {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "pencil.and.list.clipboard")
                                    .foregroundColor(.gray)
                                TextField("I want to ...", text: $taskTitle)
                                    .focused($showKeyboard)
                                    .onChange(of: taskTitle) { newValue in
                                        if !isSelecting && newValue.count > 2 {
                                            filteredSuggestions = suggestions.filter { suggestion in
                                                suggestion.lowercased().contains(newValue.lowercased())
                                            }
                                        } else {
                                            filteredSuggestions = [] // Hide if no text or too short
                                        }
                                    }
                            }

                            Spacer()

                            HStack {
                                Image(systemName: "scribble.variable")
                                    .foregroundColor(.gray)
                                TextField("Add a note", text: $taskNote)
                            }

                            Spacer(minLength: 32)

                            HStack {
                                Button(action: {
                                    showDatePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                        Text(taskDateStore.TaskDate.formatted(date: .abbreviated, time: .omitted))
                                    }
                                    .foregroundColor(.gray)
                                }
                                .buttonStyle(.bordered)
                                .padding(.trailing)

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
                            }

                            HStack {
                                if selectedTime != nil {
                                    Button(action: {
                                        showDeadlinePicker = true
                                    }) {
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

                            Spacer(minLength: 32)

                            Button(action: {
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

                    // Suggestions Overlay
                    if !filteredSuggestions.isEmpty {
                        VStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        filteredSuggestions = []
                                    }) {
                                        Image(systemName: "xmark")
                                    }
                                }.padding(.vertical, 8)
                                // Scrollable Suggestions
                                ScrollView {
                                    VStack(spacing: 8) {
                                        ForEach(filteredSuggestions, id: \.self) { suggestion in
                                            HStack {
                                                Text(suggestion)
                                                    .foregroundColor(.primary)
                                                    .font(.body)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal)
                                                    .background(Color(.systemGray6))
                                                    .cornerRadius(8)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            isSelecting = true
                                                            taskTitle = suggestion
                                                            filteredSuggestions = []
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                                isSelecting = false
                                                            }
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .frame(maxWidth: .infinity) // Full width
                            .padding(.horizontal) // Add padding on both sides
                            .background(
                                ZStack {
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [
                                                Color.indigo.opacity(0.4),
                                                Color.purple.opacity(0.4),
                                                Color.blue.opacity(0.3),
                                                Color.teal.opacity(0.4)
                                            ]
                                        ),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                }
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .animation(.easeInOut(duration: 0.3), value: filteredSuggestions)
                        }
                        .padding(.horizontal, 0) // Ensure full width by removing horizontal padding
                        .foregroundColor(.primary)
                    }

                }
            }
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
            loadSuggestions()
        }
    }

    // Load suggestions from TaskSuggestions.json
    private func loadSuggestions() {
        if let url = Bundle.main.url(
            forResource: "TaskSuggestions", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(
                [TaskSuggestion].self, from: data)
        {
            suggestions = decoded.map { $0.todo }
        }
    }
}

// Struct for decoding JSON
struct TaskSuggestion: Codable {
    let id: Int
    let todo: String
}
