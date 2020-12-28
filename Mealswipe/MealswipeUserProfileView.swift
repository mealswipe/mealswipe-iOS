//
//  MealswipeUserProfileView.swift
//  Mealswipe
//
//  Created by Brock May on 8/25/20.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore

struct MealswipeUserProfileView: View {
    @ObservedObject var firebase = SwipeObserver()
    @State var isGlutenFree = false
    @State var isVegetarian = false
    @State var isVegan = false
    var onDismiss: () -> ()
            
    var body: some View {
        
        NavigationView {
            if firebase.isLoading {
                Loader()
            } else {
                Form {
                    HStack {
                        if let user = firebase.user {
                            let url = URL(string: user.profileImageUrl)
                            WebImage(url: url)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .cornerRadius(40)
                        }
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text(firebase.user?.name ?? "")
                                .fontWeight(.bold)
                                
                            Text(firebase.user?.displayName ?? "")
                                .fontWeight(.thin)
                        })
                        
                        Spacer()
                    }
                    
                    Section(header: Text("FILTERS")) {
                        Toggle("Gluten Free", isOn: $isGlutenFree)
                        Toggle("Vegetarian", isOn: $isVegetarian)
                        Toggle("Vegan", isOn: $isVegan)
                    }
                    
                    if let user = firebase.user {
                        if user.hasSubscription {
                            Section(header: Text("Mealswipe Premium Filters")) {
                                Text("Price Range")
                                Text("Cook Time")
                                Text("Whole Food")
                                Text("Meal Type")
                            }
                        }
                    }
                    
                    Section(header: Text("Account Information")) {
                        Text("Change Username")
                        Text("Change Name")
                        Text("Change Email")
                        Text("Change Password")
                    }

                                                    
                }.onAppear {
                    firebase.fetchUserInfo()
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (time) in
                        if let user = firebase.user {
                            self.isVegan = user.isVegan
                            self.isVegetarian = user.isVegetarian
                            self.isGlutenFree = user.isGlutenFree
                        }
                    }
                }
                
                .navigationBarTitle("Account", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        updateUserInformation()
                        self.onDismiss()
                    }, label: {
                        Text("Save")
                            .foregroundColor(Color("NavBarAccent"))
                    })
                )
            }
        }
    }
    
    func updateUserInformation() {
        if let user = firebase.user {
            
            print("------------------------------------")
            print("is User Gluten Free: \(isGlutenFree)")
            print("is User Vegan: \(isVegan)")
            print("is User Vegetarian: \(isVegetarian)")
                        
            let dictionary: [String: Any] = [
                //"displayName": user.displayName,
                //"email": user.email,
                //"hasSubscription": user.hasSubscription,
                //"name": user.name,
                //"uid": user.uid,
                "isVegan": isVegan,
                "isVegetarian": isVegetarian,
                "isGlutenFree": isGlutenFree
            ]
            
            Firestore.firestore().collection("users").document(user.uid).updateData(dictionary) { (err) in
                if let error = err {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//struct MealswipeUserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealswipeUserProfileView(isPresented: T##Binding<Bool>)
//    }
//}
