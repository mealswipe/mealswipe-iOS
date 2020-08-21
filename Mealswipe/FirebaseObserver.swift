//
//  FirebaseObserver.swift
//  Mealswipe
//
//  Created by Brock May on 8/17/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

//var swipesRemaining = 0

class FirebaseObserver: ObservableObject {
    @Published var meals = [Meal]()
    @Published var swipes = [String: Any]()
    @Published var loadingMessage = ""
    @Published var isLoading = false
   
    // Fetch the meals that have not been swiped on yet
    func fetchMeals() {
        
        Firestore.firestore().collection("meals").getDocuments { (snapshot, error) in
            if let err = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.loadingMessage = err.localizedDescription
                }
                return
            }
            
            snapshot?.documents.forEach({ (docSnap) in
                let dictionary = docSnap.data()
                let meal = Meal(dictionary: dictionary)
                
                // If meal id exists within swipes array, set to false
                let hasNotSwipedBefore = self.swipes[meal.id] == nil
                
                if hasNotSwipedBefore {
                    self.meals.append(meal)
                    meal.fetchIngredients()
                }
            })
            
            self.isLoading = false
            self.showMessageWithTimer()
        }
    }
    
    func showMessageWithTimer() {
        // If there are no meals, show message immediately. Otherwise, wait until cards load into view
        DispatchQueue.main.async {
            if self.meals.count == 0 {
                self.loadingMessage = "Out of meals\nCheck your food basket"
            } else {
                Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (time) in
                    self.loadingMessage = "Out of meals\nCheck your food basket"
                }
            }
        }
    }
    
    // Fetch swipes the user made to omit meals users have already swiped on
    func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        isLoading = true
                
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snap, error) in
            if let err = error {
                self.isLoading = false
                self.loadingMessage = err.localizedDescription
                return
            }
            
            if snap?.exists == false {
                self.fetchMeals()
                print("Snapshot does not exist")
                return
            } else {
                guard let data = snap?.data() as? [String: Int] else {return}
                self.swipes = data // Sets swipes array equal to the information  found in snap.data()
                self.fetchMeals()
            }
        }
    }
    
    // Save swipe to firebase
    func saveSwipeToFirestore(didSwipeRight: Bool, meal: Meal) {
        let mealID = meal.id
        let dictionaryToInsert = didSwipeRight ? [mealID: 1] : [mealID: 0]
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(dictionaryToInsert)
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(dictionaryToInsert)
            }
        }
    }
}
