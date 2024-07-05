//
//  Environment.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/5/24.
//

import SwiftUI

struct IsPreviewKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}
