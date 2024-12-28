//
//  ScheduleNotification.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/28/24.
//
import UserNotifications

// Schedule a notification for a specific task
func ScheduleNotification(for task: Task) {
    guard let taskTime = task.time else {
        print("Skipping notification: Task has no time.")
        return
    }

    // Create notification content
    let content = UNMutableNotificationContent()
    content.title = "Reminder: \(task.title)"
    content.subtitle = "Task Deadline: \(formattedDate(taskTime))"
    content.body = task.note.isEmpty ? "It's time to focus on this task." : task.note
    content.sound = .default

    // Optionally add an attachment (e.g., an image)
    if let attachment = createAttachment(for: "notification_image") {
        content.attachments = [attachment]
    }

    // Set the trigger time
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

    // Schedule the notification
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled for task: \(task.title) at \(taskTime)")
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

// Helper function to create an attachment for the notification
private func createAttachment(for imageName: String) -> UNNotificationAttachment? {
    guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpg") else {
        return nil
    }
    do {
        let attachment = try UNNotificationAttachment(identifier: imageName, url: imageURL, options: nil)
        return attachment
    } catch {
        print("Failed to create notification attachment: \(error.localizedDescription)")
        return nil
    }
}
