//
//  GradeIcon.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 11/6/24.
//

import SwiftUI


struct GradeIcon: View {
    let score: Int?
    
    var attributes: (letter: String, color: Color) {
        guard let score else {
            return ("plus", .gray)
        }
        
        return switch score {
        case 90...100:
            ("a", .green)
        case 80...89:
            ("b", .blue)
        case 70...79:
            ("c", .orange)
        case 60...69:
            ("d", .indigo)
        case 0...59:
            ("f", .red)
        default:
            ("x", .red)
        }
    }
    
    var body: some View {
        Image(systemName: "\(attributes.letter).circle.fill")
            .resizable()
            .foregroundStyle(.white, attributes.color)
    }
}
