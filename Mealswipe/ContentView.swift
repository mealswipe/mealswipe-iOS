//
//  ContentView.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var firebase = FirebaseObserver()
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        
        // Make title text bold and set it to the Foodi Red
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        firebase.fetchSwipes()
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                ZStack {
                    Text(firebase.loadingMessage)
                        .fontWeight(.thin)
                        .font(.title)
                    
                    ForEach(self.firebase.meals) { (meal) -> MealCardView in
                        MealCardView(meal: meal)
                    }
                }
            }

            .navigationBarTitle(Text("MEALSWIPE"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
