//
//  ScheduleNotification.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/28/24.
//

import UserNotifications

// Function to schedule notifications for a specific task
func ScheduleNotification(for task: Task) {
    guard let taskTime = ZeroOutSeconds(from: task.time) else {
        print("Skipping notification: Task '\(task.title)' has no valid time.")
        return
    }
    
    print("Scheduling Start Notification for task '\(task.title)' at \(taskTime)")
    
    // Schedule start notification
    let startContent = createNotificationContent(for: task, isDeadline: false)
    scheduleNotificationAtTime(taskTime: taskTime, task: task, content: startContent, isDeadline: false)
    
    // Schedule deadline notification if available
    if let deadline = task.deadline {
        guard let deadlineTime = ZeroOutSeconds(from: deadline) else {
            print("Skipping deadline notification: Task '\(task.title)' has an invalid deadline.")
            return
        }
        print("Scheduling Deadline Notification for task '\(task.title)' at \(deadlineTime)")
        let deadlineContent = createNotificationContent(for: task, isDeadline: true)
        scheduleNotificationAtTime(
            taskTime: deadlineTime,
            task: task,
            content: deadlineContent,
            isDeadline: true
        )
    }
}

// Function to create notification content
private func createNotificationContent(for task: Task, isDeadline: Bool) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = task.title
    content.body =
        isDeadline
        ? "You missed the task deadline."
        : (task.note.isEmpty ? "It's time to start this task." : task.note)
    content.sound =
        isDeadline
        ? UNNotificationSound(named: UNNotificationSoundName("deadline_notif.mp3"))
        : UNNotificationSound(
            named: UNNotificationSoundName("start_notif.mp3"))
    return content
}

// Function to schedule a notification at a specific time
private func scheduleNotificationAtTime(
    taskTime: Date, task: Task, content: UNMutableNotificationContent, isDeadline: Bool
) {
    let triggerDate = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute],
        from: taskTime
    )

    let trigger = UNCalendarNotificationTrigger(
        dateMatching: triggerDate, repeats: false)
    
    // Use 'isDeadline' to differentiate identifiers
    let identifier =
        "\(task.id.uuidString)-\(isDeadline ? "deadline" : "start")"

    let request = UNNotificationRequest(
        identifier: identifier,
        content: content,
        trigger: trigger
    )

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print(
                "Failed to schedule notification '\(identifier)': \(error.localizedDescription)"
            )
        } else {
            print(
                "Notification '\(identifier)' scheduled: \(content.title) at \(formattedDate(taskTime))"
            )
        }
    }
}

// Helper function to format the date for logging
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
