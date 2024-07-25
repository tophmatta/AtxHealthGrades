//
//  Util.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/24/24.
//

import SwiftUI

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(TapGesture().onEnded { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
    }
}

