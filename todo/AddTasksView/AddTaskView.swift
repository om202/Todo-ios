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
    @State private var isSelecting: Bool = false // New state to handle selection

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
                                    Text(
                                        taskDateStore.TaskDate.formatted(
                                            date: .abbreviated, time: .omitted))
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
                                    Text(
                                        selectedTime?.formatted(
                                            .dateTime.hour().minute()) ?? "All day")
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
                                                : "No Deadline")
                                    }
                                    .foregroundColor(.gray)
                                }
                                .buttonStyle(.bordered)
                            }
                        }

                        Spacer(minLength: 32)

                        Button(
                            action: {
                                taskStore
                                    .addTask(
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
                        Spacer(minLength: 70) // Space for the TextField
                        List(filteredSuggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .onTapGesture {
                                    withAnimation {
                                        isSelecting = true // Prevent filtering during selection
                                        taskTitle = suggestion
                                        filteredSuggestions = []
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isSelecting = false // Re-enable filtering after delay
                                        }
                                    }
                                }
                        }
                        .listStyle(.plain)
                        .frame(height: min(200, CGFloat(filteredSuggestions.count * 44)))
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        .zIndex(1)
                        .transition(.move(edge: .top).combined(with: .opacity)) // Add transition
                        .animation(.easeInOut(duration: 0.3), value: filteredSuggestions) // Add animation
                    }
                    .padding(.horizontal)
                    .foregroundColor(.gray)
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
        if let url = Bundle.main.url(forResource: "TaskSuggestions", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([TaskSuggestion].self, from: data) {
            suggestions = decoded.map { $0.todo }
        }
    }
}

// Struct for decoding JSON
struct TaskSuggestion: Codable {
    let id: Int
    let todo: String
}
