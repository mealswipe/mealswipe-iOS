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
    
    @Published var isUserLoggedIn: Bool = false
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            isUserLoggedIn = true
            return
        }
        signin() // If you have created a account, signed in.
        // registerAccount() If you have not created an account yet
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
    
    func signin() {
        Auth.auth().signIn(withEmail: "YOUR EMAIL HERE", password: "YOUR PASSWORD HERE") { (result, error) in
            if let err = error {print(err); return;}
        }
        isUserLoggedIn = true
    }
}
