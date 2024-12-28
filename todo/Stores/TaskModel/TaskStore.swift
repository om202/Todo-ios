//
//  TaskStore.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import SwiftUI
import UserNotifications

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTaskToUserDefaults()
        }
    }
    private let tasksKey = "tasksKey"

    init() {
        loadTasksFromUserDefaults()
    }

    // Add a new task and schedule a notification
    func addTask(title: String, note: String, date: Date, time: Date?, deadline: Date?) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newTask = Task(
            title: title,
            note: note,
            date: date,
            time: time,
            deadline: deadline
        )

        tasks.append(newTask)
        HapticsManager.mediumImpact()
        scheduleNotification(for: newTask)
    }

    // Toggle task completion
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            HapticsManager.mediumImpact()
            let updatedTask = task
            updatedTask.isDone.toggle()
            tasks[index] = updatedTask
        }
    }

    // Delete tasks and cancel their notifications
    func deleteTask(at offSet: IndexSet) {
        HapticsManager.mediumImpact()
        let idsToDelete = offSet.map { tasks[$0].id.uuidString }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idsToDelete)
        tasks.remove(atOffsets: offSet)
    }

    // Request notification permission
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Failed to request notification permission: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    // Schedule a notification for a specific task
    private func scheduleNotification(for task: Task) {
        guard let taskTime = task.time else {
            print("Skipping notification: Task has no time.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.note.isEmpty ? "It's time for your task!" : task.note
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: taskTime
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for task: \(task.title) at \(taskTime)")
            }
        }
    }

    // Save tasks to UserDefaults
    private func saveTaskToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }

    // Load tasks from UserDefaults
    private func loadTasksFromUserDefaults() {
        guard let savedData = UserDefaults.standard.data(forKey: tasksKey),
              let decodedData = try? JSONDecoder().decode([Task].self, from: savedData)
        else { return }
        self.tasks = decodedData
    }
}
