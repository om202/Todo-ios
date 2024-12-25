import SwiftUI

struct TaskSection: View {
    @StateObject private var taskStore = TaskStore()
    @State private var isDone: Bool
    private let task: Task
    
    init(task: Task) {
        self.task = task
        self._isDone = State(initialValue: task.isDone)
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                if task.time != nil && !isDone {
                    TaskUpperSectionView(task: task, isDone: $isDone)
                }
                
                TaskContentView(task: task, isDone: $isDone)
                
                if !task.note.trimmingCharacters(in: .whitespaces).isEmpty {
                    TaskNoteView(note: task.note)
                }
                
                if let taskTime = task.time,
                   Date() > taskTime && !isDone {
                    TaskProgressView(task: task)
                }
            }
            .opacity(isDone ? 0.4 : 1)
            .strikethrough(isDone)
            .padding(.vertical, 4)
        }
        .padding(.vertical, 4)
        .onTapGesture {
            withAnimation {
                isDone.toggle()
                taskStore.toggleTask(task)
            }
        }
    }
}

private struct TaskContentView: View {
    let task: Task
    @Binding var isDone: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.indigo)
            
            Text(task.title)
                .padding(.leading, 8)
        }
    }
}

private struct TaskNoteView: View {
    let note: String
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.turn.down.right")
            Text(note)
        }
        .foregroundColor(.gray)
        .font(.subheadline)
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
        .strikethrough(false)
        .font(.footnote)
        .foregroundColor(.gray)
        .padding(.top, 16)
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
        .font(.subheadline)
        .foregroundColor(.gray)
    }
}

private struct TimeDisplayView: View {
    let task: Task
    let isDone: Bool
    
    var body: some View {
        HStack {
            startTimeView
            
            if task.deadline != nil {
                deadlineView
            }
        }
        .strikethrough(false)
    }
    
    private var startTimeView: some View {
        HStack {
            Image(systemName: "clock")
            Text(task.time?.formatted(.dateTime.hour().minute()) ?? "")
        }
    }
    
    private var deadlineView: some View {
        HStack {
            Image(systemName: "arrow.right")
            Text(task.deadline?.formatted(.dateTime.hour().minute()) ?? "")
        }
    }
}
