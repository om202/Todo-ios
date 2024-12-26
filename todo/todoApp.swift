//
//  todoApp.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/22/24.
//

import SwiftUI

@main
struct todoApp: App {
    @StateObject private var timeStore = GlobalTimeStore()
    @StateObject private var taskStore = TaskStore()
    @StateObject private var taskDateStore = GlobalTaskDateStore()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(timeStore)
                .environmentObject(taskStore)
                .environmentObject(taskDateStore)
        }
    }
}
