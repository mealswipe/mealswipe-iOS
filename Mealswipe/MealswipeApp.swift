//
//  MealswipeApp.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct MealswipeApp: App {
    @ObservedObject var authObserve = AuthObserver()
    
    init() {
        FirebaseApp.configure()
        authObserve.signin()
    }
    
    var body: some Scene {
        WindowGroup {
            if authObserve.isUserLoggedIn {
                ContentView()
                    .environmentObject(authObserve)
            } else {
                LoginRegisterView()
                    .environmentObject(authObserve)
            }
        }
    }
}

