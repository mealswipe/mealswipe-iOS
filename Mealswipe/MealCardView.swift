//
//  MealCardView.swift
//  Mealswipe
//
//  Created by Brock May on 8/16/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MealCardView: View {
    @ObservedObject var firebase = FirebaseObserver()
    @State private var offset = CGSize.zero
    @State private var isExpanded = false
    let threshold: CGFloat = 100
    var meal: Meal
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: meal.imageUrl))
                .resizable()
                .cornerRadius(isExpanded ? 0 : 20)
                .overlay(
                    MealCardOverlayView(offset: $offset, isExpanded: $isExpanded)
                )
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text(meal.name)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("\(meal.minutesToHours())")
                            .foregroundColor(.white)
                            .font(.headline)
                                                
                        if isExpanded {
                            MealCardRecipeView(meal: meal)
                        }
                    })
                    
                    Spacer()
                }
                
            }.padding([.bottom, .leading], 20)
            
        }.shadow(radius: 4)
        .scaleEffect(isExpanded ? 1 : 0.83)
        .cornerRadius(isExpanded ? 0 : 20)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged({ (gesture) in
                    self.offset = isExpanded ? CGSize.zero : gesture.translation
                })
                
                .onEnded({ (gesture) in
                                    
                    withAnimation(.spring()) {
                        if self.offset.width > threshold {
                            // Swipe right
                            self.offset.width = 1000
                            firebase.saveSwipeToFirestore(didSwipeRight: true, meal: self.meal)
                        } else if self.offset.width < -threshold {
                            // Swipe left
                            self.offset.width = -1000
                            firebase.saveSwipeToFirestore(didSwipeRight: false, meal: self.meal)
                        } else {
                            self.offset = CGSize.zero
                        }
                    }
                })
        )
        
        .onTapGesture {
            withAnimation(.spring(response: 0.25, dampingFraction: 1, blendDuration: 0.25)) {
                self.offset = CGSize.zero
                self.isExpanded.toggle()
            }
        }
        
    }
}

//struct MealCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealCardView()
//    }
//}


