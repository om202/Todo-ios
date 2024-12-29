import SwiftUI

struct TaskSection: View {
    var themeColor: Color = .indigo
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var globalTime: GlobalTimeStore
    @State private var isDone: Bool
    
    private let task: Task

    init(task: Task) {
        self.task = task
        self._isDone = State(initialValue: task.isDone)
    }

    var body: some View {
        Section {
            VStack(alignment: .leading) {
                // Upper Section with Time
                if task.time != nil {
                    TaskUpperSectionView(task: task, isDone: $isDone)
                }

                // Main Content View
                TaskContentView(task: task, isDone: $isDone)

                // Note Section
                if !task.note.trimmingCharacters(in: .whitespaces).isEmpty {
                    TaskNoteView(note: task.note)
                }

                // Progress View if the task is overdue
                if let taskTime = task.time,
                   globalTime.globalTime > taskTime && !isDone {
                    TaskProgressView(task: task)
                }
            }
            .opacity(isDone ? 0.4 : 1)
            .strikethrough(isDone)
            .onTapGesture {
                withAnimation {
                    isDone.toggle()
                    taskStore.toggleTask(task)
                }
            }
        }
        .listSectionSpacing(20)
        .padding(.vertical, 10)
    }
}

private struct TaskContentView: View {
    let task: Task
    @Binding var isDone: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Checkmark Icon
            Image(systemName: isDone ? "checkmark.square.fill" : "square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.indigo)

            // Task Title
            Text(task.title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 8)
        }
    }
}

private struct TaskNoteView: View {
    let note: String

    var body: some View {
        HStack {
            Image(systemName: "arrow.turn.down.right")
                .foregroundColor(.gray)
            Text(note)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding(.top, 4)
    }
}

private struct TaskProgressView: View {
    let task: Task

    var body: some View {
        HStack {
            InProgressAnimation(
                height: 5,
                startTime: task.time!,
                finishTime: task.deadline
            )
        }
        .font(.footnote)
        .foregroundColor(.gray)
        .padding(.top, 8)
    }
}

struct TaskUpperSectionView: View {
    let task: Task
    @Binding var isDone: Bool

    var body: some View {
        HStack {
            Spacer()
            TimeDisplayView(task: task, isDone: isDone)
        }
        .font(.footnote)
        .foregroundColor(.gray)
    }
}

private struct TimeDisplayView: View {
    let task: Task
    let isDone: Bool

    var body: some View {
        HStack(spacing: 8) {
            startTimeView

            if task.deadline != nil {
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)

                deadlineView
            }
        }
    }

    private var startTimeView: some View {
        HStack {
            Image(systemName: "timer")
            Text(task.time?.formatted(.dateTime.hour().minute()) ?? "")
        }
    }

    private var deadlineView: some View {
        HStack {
            Text(task.deadline?.formatted(.dateTime.hour().minute()) ?? "")
        }
    }
}
