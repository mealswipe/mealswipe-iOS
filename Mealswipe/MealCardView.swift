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
                    ZStack {
                        
                        if (isExpanded || abs(self.offset.width) > 0) {
                            Rectangle()
                                .foregroundColor(.black)
                                .opacity(0.8)
                                .cornerRadius(self.isExpanded ? 0 : 20)
                        }
                        
                        if (!isExpanded && abs(self.offset.width) == 0) {
                            LinearGradient(gradient: .init(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                                .opacity(1)
                                .cornerRadius(self.isExpanded ? 0 : 20)
                        }

                        Text("YUCK!")
                            .font(.title)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .opacity(offset.width < 0 ? 1 : 0)
                        
                        Text("YUM!")
                            .font(.title)
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                            .opacity(offset.width > 0 ? 1 : 0)
                    }
                )
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text(meal.name)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("\(minutesToHours(minutes: meal.minutes))")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        if isExpanded {
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
                                    })
                                    Spacer()
                                }
                            }.padding([.top], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
            withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0.5)) {
                self.offset = CGSize.zero
                self.isExpanded.toggle()
            }
        }
        
    }
    
    func minutesToHours(minutes: Int) -> String {
        if minutes > 60 {
            let numHours = minutes/60
            return "About \(numHours) hour\(numHours > 1 ? "s" : "")"
        } else {
            return "\(minutes) minute\(minutes > 1 ? "s" : "")"
        }
    }
}

//struct MealCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealCardView()
//    }
//}


