import LocalAuthentication
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
            VStack {
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.gray)
                
                Text("Locked")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            .padding(.top, 24)

            Spacer()

            Text("Press below to unlock using FaceID")
                .foregroundColor(.gray)

            // Retry Button
            Button(action: {
                appLockManager.authenticateUser()
            }) {
                HStack {
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .padding()
                .foregroundColor(.gray)
                .cornerRadius(8)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onAppear {
            // Automatically attempt Face ID when the lock screen appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  // half seconds delay
                if !appLockManager.failedAttempts {
                    appLockManager.authenticateUser()
                }
            }
        }
    }
}
