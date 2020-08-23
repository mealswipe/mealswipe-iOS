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
        
        // Make title text have a thin font weight
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
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
        .onAppear {
            firebase.fetchUser()
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
