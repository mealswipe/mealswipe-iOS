//
//  MealswipeApp.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct MealswipeApp: App {
    @ObservedObject var authObserve = AuthObserver()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authObserve.checkIfUserIsLoggedIn() {
                ContentView()
            } else {
                LoginRegisterView()
            }
        }
    }
}
