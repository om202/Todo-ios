//
//  DateTools.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/26/24.
//
import SwiftUI

func FormatDate(date: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    if calendar.isDateInToday(date) {
        return "Today"
    } else if calendar.isDateInTomorrow(date) {
        return "Tomorrow"
    } else if calendar.isDateInYesterday(date) {
        return "Yesterday"
    } else {
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: date)
    }
}