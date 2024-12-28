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
        ScheduleNotification(for: newTask)
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
