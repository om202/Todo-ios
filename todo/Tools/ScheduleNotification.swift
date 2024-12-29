//
//  ScheduleNotification.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/28/24.
//

import UserNotifications

// Schedule a notification for a specific task
func ScheduleNotification(for task: Task) {
    guard let taskTime = ZeroOutSeconds(from: task.time) else {
        print("Skipping notification: Task has no time.")
        return
    }

    // Schedule start notification
    let startContent = createNotificationContent(for: task, isDeadline: false)
    scheduleNotificationAtTime(taskTime: taskTime, task: task, content: startContent)

    // Schedule deadline notification if available
    let taskDeadline = ZeroOutSeconds(from: task.deadline)
    if taskDeadline != nil {
        let deadlineContent = createNotificationContent(for: task, isDeadline: true)
        scheduleNotificationAtTime(taskTime: taskDeadline ?? Date(), task: task, content: deadlineContent)
    }
}

// Create notification content
private func createNotificationContent(for task: Task, isDeadline: Bool)
    -> UNMutableNotificationContent
{
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

// Schedule notification at a specific time
private func scheduleNotificationAtTime(
    taskTime: Date, task: Task, content: UNMutableNotificationContent
) {
    let triggerDate = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute],
        from: taskTime
    )

    let trigger = UNCalendarNotificationTrigger(
        dateMatching: triggerDate, repeats: false)
    let identifier =
        "\(task.id.uuidString)-\(content.subtitle.contains("Deadline") ? "deadline" : "start")"

    let request = UNNotificationRequest(
        identifier: identifier,
        content: content,
        trigger: trigger
    )

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print(
                "Failed to schedule notification: \(error.localizedDescription)"
            )
        } else {
            print(
                "Notification scheduled: \(content.title) at \(formattedDate(taskTime))"
            )
        }
    }
}

// Helper function to format the date for the subtitle
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
