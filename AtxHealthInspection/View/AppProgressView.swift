//
//  AppProgressView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/11/24.
//

import SwiftUI


struct AppProgressView: View {
    @Binding var isEnabled: Bool
    
    var body: some View {
        if isEnabled {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .onSurface))
                .controlSize(.large)
                .padding()
                .background(.surface.opacity(0.7))
                .cornerRadius(8)
        }
    }
}
