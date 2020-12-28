////
////  MealCardView.swift
////  Mealswipe
////
////  Created by Brock May on 8/16/20.
////
//
import SwiftUI
import SDWebImageSwiftUI

struct BasketCell: View {
    var meal: Meal
    @Binding var isExpanded: Bool
    var namespace: Namespace.ID
    @State var mealId: String
    @Binding var selected: Meal
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if let url = URL(string: meal.imageUrl) {
                WebImage(url: url)
                    .resizable()
                    .cornerRadius(10)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(
                        LinearGradient(gradient: .init(colors: colorScheme == .dark ? [.clear, .black] : [.clear, .gray]), startPoint: .top, endPoint: .bottom)
                            .opacity(1)
                            .cornerRadius(10)
                    )
                    .matchedGeometryEffect(id: meal.imageUrl, in: namespace)
                
            }
            
            VStack(spacing: 4) {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(meal.name)
                            .fontWeight(.bold)
                            .font(.title)
                            .matchedGeometryEffect(id: meal.name, in: namespace)
                        Text(meal.minutesToHours())
                            .font(.headline)
                            .matchedGeometryEffect(id: meal.minutesToHours(), in: namespace)
                    }.padding([.bottom, .leading], 8)
                    Spacer()
                }
            }
        }
        .frame(height: 180)
        .offset(x: 0, y: 0)
        
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 0.5)) {
                self.selected = meal
                self.isExpanded.toggle()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("BasketCard"))
                .shadow(radius: 2)
        )
    }
}

struct DetailsView: View {
    @Binding var isExpanded: Bool
    @Binding var meal: Meal
    var namespace: Namespace.ID
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            
            ScrollView {
                if let url = URL(string: meal.imageUrl) {
                    ZStack {
                        WebImage(url: url)
                            .resizable()
                            .frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .overlay(
                                LinearGradient(gradient: .init(colors: colorScheme == .dark ? [.clear, .black] : [.clear, .gray]), startPoint: .top, endPoint: .bottom)
                                    .opacity(1)
                            )
                            .matchedGeometryEffect(id: meal.imageUrl, in: namespace)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Spacer()
                                Text(meal.name)
                                    .fontWeight(.bold)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .matchedGeometryEffect(id: meal.name, in: namespace)
                                    .multilineTextAlignment(.leading)
                                
                                Text("\(meal.minutesToHours())")
                                    .font(.headline)
                                    .matchedGeometryEffect(id: meal.minutesToHours(), in: namespace)
                                    .multilineTextAlignment(.leading)
                            }.padding([.leading, .bottom], 16)
                            
                            Spacer()
                        }
                    }
                }
                
                VStack {
                    if meal.isGlutenFree || meal.isVegan || meal.isVegetarian {
                        MealCardRecipeTagsView(meal: meal)
                            .padding([.leading], 16)
                        //                        .animation(Animation.easeOut(duration: 0.5).delay(0.5))
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            Text("Here's What You'll Need")
                                .fontWeight(.bold)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            //                            .animation(Animation.easeOut(duration: 0.5).delay(0.7))
                            
                            ForEach(self.meal.ingredients, id: \.self) { (element) in
                                Text("\(element.amount) \(element.name)")
                                    .fontWeight(.thin)
                            }
                            
                            Text("Here's How to Make It")
                                .fontWeight(.bold)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            //                            .animation(Animation.easeOut(duration: 0.5).delay(1.1))
                            
                            Text(meal.instructions)
                                .fontWeight(.thin)
                            //                            .animation(Animation.easeOut(duration: 0.5).delay(1.3))
                            
                        }).padding([.leading], 16)
                        Spacer()
                    }.padding([.top], meal.isGlutenFree || meal.isVegan || meal.isVegetarian ? 0 : 10)
                }.offset(x: 0, y: isExpanded ? 0 : -300)
                .animation(.easeInOut)
            }
        }
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 0.5)) {
                self.isExpanded.toggle()
            }
        }
        .background(
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var uiVisualEffect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = uiVisualEffect
    }
}
//
struct MealCardView: View {
    @ObservedObject var firebase = SwipeObserver()
    @State private var offset = CGSize.zero
    let threshold: CGFloat = 100
    var meal: Meal
    
    @Binding var isExpanded: Bool
    var namespace: Namespace.ID
    @State var mealId: String
    @Binding var selected: Meal
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            WebImage(url: URL(string: meal.imageUrl))
                .resizable()
                .cornerRadius(isExpanded ? 0 : 20)
                .overlay(
                    MealCardOverlayView(offset: $offset, isExpanded: $isExpanded)
                )
                .matchedGeometryEffect(id: meal.imageUrl, in: namespace)

            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text(meal.name)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .matchedGeometryEffect(id: meal.name, in: namespace)

                        Text("\(meal.minutesToHours())")
                            .foregroundColor(.white)
                            .font(.headline)
                            .matchedGeometryEffect(id: meal.minutesToHours(), in: namespace)
                    })

                    Spacer()
                }

            }.padding([.bottom, .leading], 20)

        }
        .frame(width: UIScreen.main.bounds.width * 0.90, height: UIScreen.main.bounds.height * 0.75)
        .shadow(radius: 4)
        .cornerRadius(20)
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
                self.selected = meal
                self.isExpanded.toggle()
            }
        }

    }
}
//
//
////struct MealCardView_Previews: PreviewProvider {
////    static var previews: some View {
////        MealCardView()
////    }
////}
//
//
