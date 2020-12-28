//
//  FoodBasketObserver.swift
//  Mealswipe
//
//  Created by Brock May on 8/29/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FoodBasketObserver: ObservableObject {
    @Published var swipes = [String: Any]()
    @Published var foodBasketMeals = [Meal]()
     
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if let dictionary = snapshot?.data() {
                let user = MealswipeUser(dictionary: dictionary)
                self.fetchSwipes(user: user)
            }
        }
    }
    
    // Fetch swipes the user made to omit meals users have already swiped on
    func fetchSwipes(user: MealswipeUser) {
//        isLoading = true
        
        Firestore.firestore().collection("swipes").document(user.uid).addSnapshotListener { (snap, error) in
            if let err = error {
//                self.isLoading = false
//                self.loadingMessage = err.localizedDescription
                return
            }
            
            if snap?.exists == false {
                self.fetchMeals(user: user)
                print("Snapshot does not exist")
                return
            } else {
                guard let data = snap?.data() as? [String: Int] else {return}
                self.swipes = data // Sets swipes array equal to the information  found in snap.data()
                self.fetchMeals(user: user)
            }
        }
    }
    
    // Fetch the meals that have not been swiped on yet
    func fetchMeals(user: MealswipeUser) {
        
        self.foodBasketMeals.removeAll()
        let query = Firestore.firestore().collection("meals").limit(to: 50)
                
        query.getDocuments { (snapshot, error) in
            if let err = error {
                DispatchQueue.main.async {
                    print(err.localizedDescription)
//                    self.isLoading = false
//                    self.loadingMessage = err.localizedDescription
                }
                return
            }
            
            snapshot?.documents.forEach({ (docSnap) in
                let dictionary = docSnap.data()
                let meal = Meal(dictionary: dictionary)
                
                // If swiped right on meal
                let hasSwipedRight = self.swipes[meal.id] as? Int == 1
                
                if hasSwipedRight {
                    self.foodBasketMeals.append(meal)
                    meal.fetchIngredients()
                }
            })
        }
    }
}
