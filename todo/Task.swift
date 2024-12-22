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
    var isDone: Bool
    
    init(id: UUID = UUID(), title: String = "", isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}
