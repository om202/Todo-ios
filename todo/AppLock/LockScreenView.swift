//
//  LockScreenView.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/28/24.
//
import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var appLockManager: AppLockManager

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.indigo)

            Text("Locked")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.indigo)

            Button(action: {
                appLockManager.authenticateUser()
            }) {
                HStack {
                    Image(systemName: "faceid")
                    Text("Unlock with Face ID")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.indigo.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
        .padding()
    }
}
