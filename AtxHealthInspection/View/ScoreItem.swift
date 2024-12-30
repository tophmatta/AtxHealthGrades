//
//  ScoreItem.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/6/24.
//

import SwiftUI


struct ScoreItem: View {
    let values: (letter: String, color: Color)
    
    private static func scoreForNum(_ score: Int) -> (letter: String, color: Color) {
        switch score {
        case 90...100:
            return ("A", Color.green)
        case 80...89:
            return ("B", Color.blue)
        case 70...79:
            return ("C", Color.orange)
        case 60...69:
            return ("D", Color.indigo)
        case 0...59:
            return ("F", Color.red)
        default:
            return ("?", Color.gray)
        }
    }

    init(_ score: Int) {
        self.values = ScoreItem.scoreForNum(score)
    }

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(values.color)
            Text(values.letter)
                .foregroundStyle(Color.white)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .font(.title)
        }
    }
}
