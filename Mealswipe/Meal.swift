//
//  Meal.swift
//  Foodi
//
//  Created by Brock May on 1/14/20.
//  Copyright © 2020 Brock May. All rights reserved.
//

import Foundation
import UIKit

struct Meal: Identifiable {
    var id: String
    var name: String
    var minutes: Int
    var imageUrl: String
//    var ingredients: [Ingredient] // List of ingredients to go into recipe
    
    init(dictionary: [String:Any]) {
        self.id = dictionary["mealID"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.minutes = dictionary["minutes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}





