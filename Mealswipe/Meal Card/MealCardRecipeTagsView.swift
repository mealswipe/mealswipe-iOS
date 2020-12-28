//
//  MealCardRecipeTagsView.swift
//  Mealswipe
//
//  Created by Brock May on 8/28/20.
//

import SwiftUI

struct MealCardRecipeTagsView: View {
    var meal: Meal
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 6) {
                if meal.isGlutenFree {
                    Text("Gluten Free")
                        .foregroundColor(.white)
                        .padding(.all, 4)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                if meal.isVegan {
                    Text("Vegan")
                        .foregroundColor(.white)
                        .padding(.all, 4)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                
                if meal.isVegetarian {
                    Text("Vegetarian")
                        .foregroundColor(.white)
                        .padding(.all, 4)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }.padding([.top, .bottom], 4)
    }
}

