//
//  TaskStore.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import SwiftUI

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

    func addTask(title: String, note: String, date: Date, time: Date?, deadline: Date?) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let newTask = Task(
            title: title,
            note: note,
            date: date,
            time: time,
            deadline: deadline
        )
        tasks.append(newTask)
    }
    

    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let updatedTask = task
            tasks[index].isDone.toggle()
            tasks[index] = updatedTask
        }
    }

    func deleteTask(at offSet: IndexSet) {
        tasks.remove(atOffsets: offSet)
    }

    private func saveTaskToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }

    private func loadTasksFromUserDefaults() {
        guard let savedData = UserDefaults.standard.data(forKey: tasksKey),
            let decodedData = try? JSONDecoder().decode(
                [Task].self,
                from: savedData
            )
        else { return }
        self.tasks = decodedData
    }

}
