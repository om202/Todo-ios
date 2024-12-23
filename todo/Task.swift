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
    var date: Date
    var isDone: Bool

    init(
        id: UUID = UUID(),
        title: String = "",
        date: Date = Date(),
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.isDone = isDone
    }
}
