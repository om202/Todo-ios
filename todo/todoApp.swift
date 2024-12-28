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
    @StateObject private var appLockManager = AppLockManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if appLockManager.isAppLocked {
                    LockScreenView()
                        .environmentObject(appLockManager)
                } else {
                    MainView()
                        .environmentObject(timeStore)
                        .environmentObject(taskStore)
                        .environmentObject(taskDateStore)
                        .onAppear {
                            NotificationCenter.default.addObserver(
                                forName: UIApplication.willResignActiveNotification,
                                object: nil,
                                queue: .main
                            ) { _ in
                                appLockManager.isAppLocked = true
                                appLockManager.failedAttempts = false // Reset failed state
                            }
                        }
                }
            }
        }
    }
}
