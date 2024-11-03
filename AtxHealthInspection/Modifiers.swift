//
//  Modifiers.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 10/28/24.
//

import SwiftUICore


extension View {
    func annotationSize() -> some View {
        modifier(AnnoationSize())
    }
    
    func buttonSize() -> some View {
        modifier(ButtonSize())
    }
}

private struct ButtonSize: ViewModifier {
    private let constant: CGFloat = 30.0
    
    func body(content: Content) -> some View {
        content
            .frame(width: constant, height: constant)
    }
}

private struct AnnoationSize: ViewModifier {
    private let constant: CGFloat = 35.0
    
    func body(content: Content) -> some View {
        content
            .frame(width: constant, height: constant)
    }
}
