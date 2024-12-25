//
//  TaskSection.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/24/24.
//

import SwiftUI


import SwiftUI

struct InProgressAnimation: View {
    var height: CGFloat
    var startTime: Date
    var finishTime: Date?

    @State private var progress: CGFloat = 0.0 // Tracks progress for determinate mode
    @State private var barOffset: CGFloat = 0.0 // Tracks animation position
    @State private var isAnimating = false // Toggles for infinite animation

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: height / 2)
                    .frame(height: height)
                    .foregroundColor(.gray.opacity(0.3))

                if finishTime != nil {
                    // Determinate progress bar
                    RoundedRectangle(cornerRadius: height / 2)
                        .frame(width: geometry.size.width * progress, height: height)
                        .foregroundColor(.indigo)
                        .animation(.linear(duration: 0.2), value: progress)
                } else {
                    // Indeterminate animated bar
                    RoundedRectangle(cornerRadius: height / 2)
                        .frame(width: geometry.size.width * 0.3, height: height) // Fixed segment width
                        .foregroundColor(.indigo)
                        .offset(x: barOffset) // Controlled by animation
                        .onAppear {
                            startIndeterminateAnimation(totalWidth: geometry.size.width)
                        }
                }
            }
            .cornerRadius(10)
            .clipped()
        }
        .frame(height: height)
        .onAppear {
            if finishTime != nil {
                calculateProgress()
                startProgressTimer()
            }
        }
        .onDisappear {
            // Cleanup any timers or animations
            isAnimating = false
        }
    }

    private func calculateProgress() {
        guard let finishTime = finishTime else { return }
        let totalTime = finishTime.timeIntervalSince(startTime)
        let elapsedTime = Date().timeIntervalSince(startTime)
        progress = CGFloat(min(max(elapsedTime / totalTime, 0), 1)) // Clamp between 0 and 1
    }

    private func startProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            calculateProgress()
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }

    private func startIndeterminateAnimation(totalWidth: CGFloat) {
        isAnimating = true
        barOffset = -totalWidth * 0.3 // Start off-screen (left side)
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            barOffset = totalWidth // Move fully across
        }
    }
}
struct TaskSection: View {
    @StateObject private var taskStore = TaskStore()
    var task: Task

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) { // Adjusted spacing
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
                if let taskTime = task.time, Date() > taskTime && !task.isDone {
                    HStack {
                        Text("In Progress")
                        InProgressAnimation(
                            height: 5,
                            startTime: taskTime,
                            finishTime: task.deadline
                        )
                    }
                    .strikethrough(false)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 16)
                }
            }
            .opacity(task.isDone ? 0.4 : 1)
            .strikethrough(task.isDone)
            .padding(.vertical, 4)
        }
        .padding(.vertical, 4)
        .onTapGesture {
            withAnimation {
                taskStore.toggleTask(task)
            }
        }
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

                    if let deadline = task.deadline, Date() > deadline && !task.isDone {
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
