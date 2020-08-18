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
        let displayName = "WHATEVER USERNAME YOU WANT"
        let name = "YOUR ACTUAL NAME"
        let password = "PASSWORD HERE"
        let email = "YOUR EMAIL HERE"
        
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
            
            let dictionary: [String: Any] = [
                "displayName": displayName,
                "email": email,
                "hasSubscription": false,
                "name": name,
                "uid": Auth.auth().currentUser?.uid ?? ""
            ]
            
            Firestore.firestore().collection("users").addDocument(data: dictionary) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
                
                print("User data successfully saved to firestore")
            }
        }
    }
}
