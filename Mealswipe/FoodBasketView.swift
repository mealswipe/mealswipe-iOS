//
//  FoodBasketView.swift
//  Mealswipe
//
//  Created by Brock May on 8/28/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct FoodBasketView: View {
    @ObservedObject var foodBasketObserver = FoodBasketObserver()
    @State var filterText = ""
    @State var isSearching = false
    @State var isExpanded = false
    @Namespace var namespace
    @State var selectedMeal: Meal = Meal()
    
    init() {
        // Make title text have a thin font weight
        let textAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin) ]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        foodBasketObserver.fetchUser()
    }
    
    var body: some View {
        
        if foodBasketObserver.foodBasketMeals.count == 0 {
            Text("Swipe through some meals")
                .navigationTitle(Text("Food Basket"))
        } else {
            GeometryReader { reader in
                ScrollView {
                    VStack(spacing: 16) {
                        SearchBar(filterText: $filterText, isSearching: $isSearching)
                        
                        ForEach(foodBasketObserver.foodBasketMeals.filter({"\($0.name)".contains(filterText) || filterText.isEmpty})) { (element) in
                            BasketCell(meal: element, isExpanded: $isExpanded, namespace: namespace, mealId: element.id, selected: $selectedMeal)
                                .padding(.horizontal, 16)
                        }
                    }
                    .navigationTitle(Text("Food Basket"))
                    .navigationBarHidden(isExpanded ? true : false)
                    
//                    .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0.5))
                }
                
                if isExpanded {
                    ZStack {
                        DetailsView(isExpanded: $isExpanded, meal: $selectedMeal, namespace: namespace)
                            .edgesIgnoringSafeArea(.vertical)
                    }
                }
            }
        }
    }
}

struct FoodBasketView_Previews: PreviewProvider {
    static var previews: some View {
        FoodBasketView()
    }
}

struct SearchBar: View {
    @Binding var filterText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            TextField("Search for your meals here...", text: $filterText)
                .padding(.leading, 24)
        }
         .padding(.horizontal)
         .frame(height: 50)
         .background(Color(.systemGray5).cornerRadius(10))
         .padding()
         .onTapGesture {
            isSearching = true
         }
        
         .overlay(
             HStack {
                Image(systemName: "magnifyingglass")
                Spacer()
                
                if isSearching {
                    Button {
                        filterText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.vertical)
                    }

                }
                
             }.foregroundColor(.gray)
              .padding(.horizontal, 32)
              
         )
        .animation(.easeInOut(duration: 0.10))

    }
}


