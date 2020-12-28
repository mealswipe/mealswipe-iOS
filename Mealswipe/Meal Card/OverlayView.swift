//
//  OverlayView.swift
//  Mealswipe
//
//  Created by Brock May on 8/21/20.
//

import SwiftUI

struct MealCardOverlayView: View {
    
    @Binding var offset: CGSize
    @Binding var isExpanded: Bool
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.black)
                .opacity(offset.width > 0 || offset.width < 0 ? 0.8 : 0)
                .cornerRadius(20)
                
            
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
                .animation(.easeInOut)
            
            Text("YUM!")
                .font(.title)
                .foregroundColor(.green)
                .fontWeight(.bold)
                .opacity(offset.width > 0 ? 1 : 0)
                .animation(.easeInOut)
        }
    }
}

