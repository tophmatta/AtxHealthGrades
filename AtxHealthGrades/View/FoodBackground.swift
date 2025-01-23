//
//  FoodBackground.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/5/24.
//

import SwiftUI

struct FoodBackground: View {
    private let darkGreen = Color(red: 41.0, green: 153.0, blue: 71.0)
    private let offset: CGFloat = 70.0
    
    
    var body: some View {
        ZStack {
            // for some reason not having this fucks up the layout
            GeometryReader { geometry in
                ForEach(0..<20) { row in
                    ForEach(0..<20) { column in
                        Image(systemName: "fork.knife")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                            .foregroundColor(Color.green.opacity(0.3))
                            .offset(x: CGFloat(row) * offset, y: CGFloat(column) * offset)
                    }
                }
            }
            .overlay(GradientOverlay())
            .ignoresSafeArea()
        }
    }
}

private struct GradientOverlay: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.black, .green.opacity(0.4)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.colorDodge)
    }
}


#Preview {
    FoodBackground()
}
