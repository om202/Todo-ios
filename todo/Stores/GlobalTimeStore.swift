//
//  TimeStore.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/26/24.
//

import SwiftUI

class GlobalTimeStore: ObservableObject {
    @Published var globalTime: Date = Date()
    private var timer: Timer?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.globalTime = Date()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
