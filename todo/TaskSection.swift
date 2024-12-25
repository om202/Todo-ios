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
                    HStack {
                        Spacer()
                        HStack {
                            Image(
                                systemName: "clock")
                            Text(
                                task.time?
                                    .formatted(
                                        .dateTime
                                            .hour()
                                            .minute()
                                    ) ?? ""
                            )
                            
                            if task.deadline != nil
                            {
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
                
                HStack {
                    Image(
                        systemName: task.isDone
                        ? "checkmark.circle.fill"
                        : "circle"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    VStack {
                        Text(task.title)
                    }
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
        .padding(.vertical, 8)
        .onTapGesture {
            withAnimation {
                taskStore.toggleTask(task)
            }
        }
    }
}
