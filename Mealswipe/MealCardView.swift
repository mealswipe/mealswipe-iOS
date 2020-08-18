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
    let threshold: CGFloat = 100
    var meal: Meal?
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: meal?.imageUrl ?? ""))
                .resizable()
                .cornerRadius(20)
                .overlay(
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black)
                            .opacity(abs(offset.width) > 0 ? 0.8 : 0)
                            .cornerRadius(20)
                        
                        LinearGradient(gradient: .init(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                            .opacity(abs(offset.width) == 0 ? 1 : 0)
                            .cornerRadius(20)
                        
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
                    VStack(alignment: .leading, spacing: 4, content: {
                        Text(meal?.name ?? "")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("\(minutesToHours(minutes: meal?.minutes ?? 0))")
                            .foregroundColor(.white)
                            .font(.headline)
                    })
                    
                    Spacer()
                }
            }.padding([.bottom, .leading], 20)
            
        }.scaleEffect(0.90)
        .cornerRadius(20)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged({ (gesture) in
                    self.offset = gesture.translation
                })
                
                .onEnded({ (gesture) in
                    withAnimation(.spring()) {
                        if self.offset.width > threshold {
                            // Swipe right
                            self.offset.width = 1000
                            firebase.saveSwipeToFirestore(didSwipeRight: true, meal: self.meal!)
                        } else if self.offset.width < -threshold {
                            // Swipe left
                            self.offset.width = -1000
                            firebase.saveSwipeToFirestore(didSwipeRight: false, meal: self.meal!)
                        } else {
                            self.offset = CGSize.zero
                        }
                    }
                })
        )
        .shadow(radius: 4)
    }
    
    func minutesToHours(minutes: Int) -> String {
        if minutes > 60 {
            let numHours = minutes/60
            print(numHours)
            return "About \(numHours) hour\(numHours > 1 ? "s" : "")"
        } else {
            return "\(minutes) minute\(minutes > 1 ? "s" : "")"
        }
    }
}

struct MealCardView_Previews: PreviewProvider {
    static var previews: some View {
        MealCardView()
    }
}


