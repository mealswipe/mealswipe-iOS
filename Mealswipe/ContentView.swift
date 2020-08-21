//
//  ContentView.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var firebase = FirebaseObserver()
    @State var numCards: Int = 0
    
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
        numCards = firebase.numCards
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                ZStack {
                    
                    if firebase.isLoading {
                        Loader()
                    } else {
                        Text(firebase.loadingMessage)
                            .fontWeight(.thin)
                            .font(.title)
                    }
                    
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

struct Loader : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {}
}
