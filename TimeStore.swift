//
//  TimeStore.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/26/24.
//

import SwiftUI

class TimeStore: ObservableObject {
    @Published var time: Time = Time(time: Date())
}
