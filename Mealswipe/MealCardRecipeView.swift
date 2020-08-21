//
//  MealCardRecipeView.swift
//  Mealswipe
//
//  Created by Brock May on 8/21/20.
//

import SwiftUI

struct MealCardRecipeView: View {
    var meal: Meal
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Here's What You'll Need")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                    ForEach(self.meal.ingredients, id: \.self) { (element) in
                        Text("\(element.amount) \(element.name)")
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                    }
                    
                    Text("Here's How to Make It")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                    Text(meal.instructions)
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                })
                Spacer()
            }
        }.padding([.top], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

