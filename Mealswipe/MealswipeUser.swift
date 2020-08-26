//
//  MealswipeUser.swift
//  Mealswipe
//
//  Created by Brock May on 8/23/20.
//

import Foundation
import FirebaseFirestore

class MealswipeUser {
    var displayName: String
    var email: String
    var hasSubscription: Bool
    var isGlutenFree: Bool
    var isVegan: Bool
    var isVegetarian: Bool
    var name: String
    var uid: String
    var profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.displayName = dictionary["displayName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.hasSubscription = dictionary["hasSubscription"] as? Bool ?? false
        self.isGlutenFree = dictionary["isGlutenFree"] as? Bool ?? false
        self.isVegan = dictionary["isVegan"] as? Bool ?? false
        self.isVegetarian = dictionary["isVegetarian"] as? Bool ?? false
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
