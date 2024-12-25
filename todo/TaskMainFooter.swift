//
//  TaskMainFooter.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/24/24.
//

import SwiftUI

struct TaskMainFooter: View {
    @Binding var selectedDate: Date
    @Binding var editTask: Bool
    var formattedDate: String
    
    func addDays(_ days: Int) {
        if let newDate = Calendar.current.date(
            byAdding: .day, value: days, to: selectedDate)
        {
            selectedDate = newDate
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Date Navigation Controls
                
                HStack {
                    Button(action: { addDays(-1) }) {
                        Image(systemName: "arrow.left")
                    }
                    .buttonStyle(.borderless)
                    .padding(.trailing, 8)
                    .font(.title2)
                    .foregroundColor(.gray)
                    
                    Button("\(formattedDate)") {}
                        .buttonStyle(.plain)
                    
                    Button(action: { addDays(1) }) {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.borderless)
                    .padding(.leading, 8)
                    .font(.title2)
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Add Button
                Button(action: {
                    withAnimation {
                        editTask.toggle()
                    }
                }) {
                    Label {
                        Text("Add Task")
                            .padding(.leading, 8)
                    } icon: {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(.indigo)
                }.buttonStyle(.plain)
            }
            .foregroundColor(.primary)
            .padding()
            .bold()
        }
    }
}
