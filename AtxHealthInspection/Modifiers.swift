//
//  Modifiers.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 10/28/24.
//

import SwiftUICore
import UIKit


struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func annotationSize() -> some View {
        modifier(AnnotationSize())
    }
    
    func buttonSize() -> some View {
        modifier(ButtonSize())
    }
}

private struct ButtonSize: ViewModifier {
    private let constant: CGFloat = 50.0
    
    func body(content: Content) -> some View {
        content
            .frame(width: constant, height: constant)
    }
}

private struct AnnotationSize: ViewModifier {
    private let constant: CGFloat = 35.0
    
    func body(content: Content) -> some View {
        content
            .frame(width: constant, height: constant)
    }
}
