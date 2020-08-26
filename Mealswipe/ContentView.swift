//
//  ContentView.swift
//  Mealswipe
//
//  Created by Brock May on 8/14/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject var firebase = FirebaseObserver()
    @State var showSettingsView = false
    
    init() {
        
        // Make title text have a thin font weight
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        firebase.fetchUserInfo()
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
            .navigationBarItems(leading:
                Button(action: {
                    print("presenting view")
                    showSettingsView.toggle()
                }, label: {
                    if let user = firebase.user {
                        let url = URL(string: user.profileImageUrl)
                        WebImage(url: url)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(20)
                    }
                }).offset(x: 0, y: -5)
            )
        }
        
        .onAppear {
            if showSettingsView == false {
                firebase.fetchUserSwipes()
            }
        }
        
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
