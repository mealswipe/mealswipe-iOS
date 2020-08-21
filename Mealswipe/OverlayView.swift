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
    }
}

