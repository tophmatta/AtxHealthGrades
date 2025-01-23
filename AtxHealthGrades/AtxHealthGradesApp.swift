//
//  AtxHealthGradesApp.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI
import SwiftData

@main
struct AtxHealthGradesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

var isTesting: Bool {
    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}
