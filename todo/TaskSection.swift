//
//  TaskSection.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/24/24.
//

import SwiftUI

struct TaskSection: View {
    @StateObject private var taskStore = TaskStore()
    var task: Task

    var body: some View {
        Section {
            VStack(alignment: .leading) {
                if task.time != nil {
                    TaskUpperSectionView(taskStore: taskStore, task: task)
                }

                HStack {
                    Image(
                        systemName: task.isDone
                            ? "checkmark.circle.fill"
                            : "circle"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.indigo)
                    
                    Text(task.title)
                        .padding(.leading, 8)
                }

                if !task.note.trimmingCharacters(
                    in: .whitespaces
                ).isEmpty {
                    HStack {
                        Image(
                            systemName:
                                "arrow.turn.down.right"
                        )
                        Text(task.note)
                    }
                    .foregroundColor(.gray)
                    .font(.subheadline)
                }
            }
            .opacity(task.isDone ? 0.4 : 1)
            .strikethrough(task.isDone)
        }
        .onTapGesture {
            withAnimation {
                taskStore.toggleTask(task)
            }
        }
        .padding(.vertical, 8)
    }
}

struct TaskUpperSectionView: View {
    var taskStore: TaskStore
    var task: Task

    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image(systemName: "clock")
                Text(
                    task.time?.formatted(
                        .dateTime
                            .hour()
                            .minute()
                    ) ?? ""
                )

                if task.deadline != nil {
                    Image(
                        systemName:
                            "arrow.right"
                    )
                    Text(
                        task.deadline?
                            .formatted(
                                .dateTime
                                    .hour()
                                    .minute()
                            ) ?? ""
                    )

                    if let deadline =
                        task.deadline,
                        Date()
                            > deadline
                    {
                        Text("Delayed")
                            .font(
                                .subheadline
                            )
                            .foregroundColor(
                                .red
                            )
                            .bold()
                    }
                }
            }
            .strikethrough(false)
        }
        .font(.subheadline)
        .foregroundColor(.gray)
    }
}
