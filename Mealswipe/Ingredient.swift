//
//  Ingredient.swift
//  Foodi
//
//  Created by Brock May on 1/15/20.
//  Copyright © 2020 Brock May. All rights reserved.
//

import Foundation
import UIKit

struct Ingredient {
    var name: String
    var amount: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.amount = dictionary["amount"] as? String ?? ""
    }
}
