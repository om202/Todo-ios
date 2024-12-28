//
//  AppLockManager.swift
//  todo
//
//  Created by Omprakash Sah Kanu on 12/28/24.
//

import LocalAuthentication
import SwiftUI

class AppLockManager: ObservableObject {
    @Published var isAppLocked: Bool = true
    @Published var failedAttempts: Bool = false

    func authenticateUser() {
        // Reset failed attempts every time we start authentication
        failedAttempts = false

        // Always create a new context for authentication
        let context = LAContext()
        var error: NSError?

        // Check if biometrics are available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock the app to continue."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Unlock the app
                        self.isAppLocked = false
                        self.failedAttempts = false
                    } else {
                        // Authentication failed
                        self.failedAttempts = true
                        print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            // Biometrics not available
            DispatchQueue.main.async {
                self.failedAttempts = true
                print("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
