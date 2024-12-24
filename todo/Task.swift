//
//  Task.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import Foundation

class Task: Identifiable, Codable {
    let id: UUID
    let title: String
    let note: String
    var date: Date
    var time: Date?
    var deadline: Date?
    var isDone: Bool

    init(
        id: UUID = UUID(),
        title: String = "",
        note: String = "",
        date: Date = Date(),
        time: Date? = nil,
        deadline: Date? = nil,
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.date = date
        self.time = time
        self.deadline = deadline
        self.isDone = isDone
    }
}
