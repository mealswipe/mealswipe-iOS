//
//  ContentView.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject var firebase = SwipeObserver()
    @State var showSettingsView = false
    @State var isExpanded = false
    @Namespace var namespace
    @State var selectedMeal: Meal = Meal()
    
    init() {
        
        // Make title text have a thin font weight
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        firebase.fetchUserInfo()
        firebase.fetchUserSwipes()
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                GeometryReader { reader in
                    ZStack {
                        if firebase.isLoading {
                            Loader()
                        } else {
                            Text(firebase.loadingMessage)
                                .fontWeight(.thin)
                                .font(.title)
                        }
                        
                        ForEach(self.firebase.meals) { (meal) -> MealCardView in
                            MealCardView(meal: meal, isExpanded: $isExpanded, namespace: namespace, mealId: meal.id, selected: $selectedMeal)
                        }
                        
                        if isExpanded {
                            DetailsView(isExpanded: $isExpanded, meal: $selectedMeal, namespace: namespace)
                                .edgesIgnoringSafeArea(.vertical)
                        }
                    }.position(x: reader.size.width / 2, y: reader.size.height / 2)
                }
                
            }.edgesIgnoringSafeArea(.bottom)
            
            .navigationBarTitle(Text("MEALSWIPE"), displayMode: .inline)
            .navigationBarItems(leading: UserButton(showSettingsView: $showSettingsView), trailing: NavigationLink(destination: FoodBasketView(), label: {
                Text("Basket")
                    .foregroundColor(Color("NavBarAccent"))
            }))
            
            .navigationBarHidden(isExpanded ? true : false)
            
        }.accentColor(Color("NavBarAccent"))
        
        .sheet(isPresented: $showSettingsView) {
            MealswipeUserProfileView {
                self.showSettingsView = false
                firebase.meals.removeAll()
                firebase.fetchUserSwipes()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Loader : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {}
}

struct UserButton: View {
    @Binding var showSettingsView: Bool
    
    var body: some View {
        Button {
            showSettingsView.toggle()
        } label: {
            Text("Account")
                .foregroundColor(Color("NavBarAccent"))
        }
        
    }
}
