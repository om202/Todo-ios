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

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports Face ID or Touch ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock the app to continue."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAppLocked = false
                    } else {
                        // Handle failure (e.g., show an alert)
                        print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            // No biometrics available
            print("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
