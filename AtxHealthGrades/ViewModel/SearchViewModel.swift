//
//  SearchViewModel.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation
import SwiftUI

@MainActor
@Observable final class SearchViewModel {
    let client: SocrataClientProtocol
    var currentReports = [Report]()
    
    init(_ client: SocrataClientProtocol) {
        self.client = client
    }

    func clear() {
        currentReports = [Report]()
    }
    
    func triggerSearch(value: String) async throws {
        currentReports = try await client.getReports(byName: value).filterOldDuplicates()
    }
}
