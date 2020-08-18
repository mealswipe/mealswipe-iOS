//
//  AuthObserver.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthObserver: ObservableObject {
    
    func checkIfUserIsLoggedIn() -> Bool {
        if Auth.auth().currentUser?.uid != nil { return true }
        return false
    }
    
    func registerAccount() {
        let displayName = "brockm98"
        let username = "Brock May"
        let password = "password"
        let email = "brockcm98@gmail.com"
        
        if !checkIfUserIsLoggedIn() {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.commitChanges(completion: { (error) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                    
                    print("Display name set to \(String(describing: request?.displayName))")
                })
            }
            
            print(Auth.auth().currentUser?.uid)
        }
    }
}
