//
//  FoodBackground.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/5/24.
//

import SwiftUI

struct FoodBackground: View {
    private let darkGreen = Color(red: 41, green: 153, blue: 71)
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                darkGreen
                ForEach(0..<25) { row in
                    ForEach(0..<25) { column in
                        Image(systemName: "fork.knife")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.green.opacity(0.1))
                            .offset(x: CGFloat(row) * 60, y: CGFloat(column) * 60)
                    }
                }
            }
        }
    }
}

#Preview {
    FoodBackground()
}
