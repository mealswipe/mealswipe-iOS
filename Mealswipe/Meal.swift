//
//  Meal.swift
//  Foodi
//
//  Created by Brock May on 1/14/20.
//  Copyright © 2020 Brock May. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class Meal: Identifiable {
    var id: String
    var name: String
    var minutes: Int
    var imageUrl: String
    var ingredients: [Ingredient] // List of ingredients to go into recipe
    var instructions: String
    
    init(dictionary: [String:Any]) {
        self.id = dictionary["mealID"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.minutes = dictionary["minutes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ingredients = [Ingredient]()
        self.instructions = dictionary["instructions"] as? String ?? ""
    }
    
    func fetchIngredients() {
        Firestore.firestore().collection("ingredients").document(self.id).collection("ingredients").getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            snapshot?.documents.forEach({ (snap) in
                let dictionary = snap.data()
                let ingredient = Ingredient(dictionary: dictionary)
                self.ingredients.append(ingredient)
            })
        }
    }
    
    func minutesToHours() -> String {
        if self.minutes >= 60 {
            let (hours, calculatedMinutes) = minutes.quotientAndRemainder(dividingBy: 60)
            let hoursString = "\(hours) hour\(hours > 1 ? "s" : "")"
            let minutesString = calculatedMinutes > 0 ? " \(calculatedMinutes) minute\(calculatedMinutes > 1 ? "s" : "")" : ""
            return hoursString + minutesString
        } else {
            return "\(minutes) minute\(minutes > 1 ? "s" : "")"
        }
    }
}





