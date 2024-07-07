//
//  Extensions.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/5/24.
//

import SwiftUI

extension Color {
    static let systemBackground = Color(UIColor.systemBackground)
}

extension Data {
    #if DEBUG
    func prettyPrint() -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
    #endif
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    #if DEBUG
    func printUnicodeScalars() {
        for (index, scalar) in unicodeScalars.enumerated() {
            print("Character at index \(index): '\(scalar)' (Unicode: U+\(String(format:"%04X", scalar.value)))")
        }
    }
    #endif
}
