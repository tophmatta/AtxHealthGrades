//
//  FavoritesManager.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/15/24.
//

import Foundation
import Combine


actor FavoritesManager {
    private let defaults: UserDefaults
    
    init() {
        // Set this up here bc Swift 6 was complaining about UserDefaults being non-sendable in test class
        if isTesting {
            guard let userDefaults = UserDefaults(suiteName: #file) else {
                fatalError("failed to setup test user defaults")
            }
            userDefaults.removePersistentDomain(forName: #file)
            self.defaults = userDefaults
        } else {
            self.defaults = UserDefaults.standard
        }
    }
    
    func toggleValue(report: Report) {
        let values = getValues()
        let favoriteExists = values[report.facilityId] != nil
        if favoriteExists {
            remove(report)
        } else {
            add(report)
        }
    }
    
    private func add(_ report: Report) {
        var values = getValues()
        values[report.facilityId] = report.restaurantName
        persist(values)
    }
    
    private func remove(_ report: Report) {
        var values = getValues()
        values.removeValue(forKey: report.facilityId)
        persist(values)
    }
    
    private func persist(_ values: [String: String]) {
        defaults.set(values, forKey: UserDefaultsKeys.favorites)
    }
    
    func getValues() -> [String: String] {
        defaults.dictionary(forKey: UserDefaultsKeys.favorites) as? [String : String] ?? [:]
    }
}

private struct UserDefaultsKeys {
    static let favorites = "favoriteIDs"
}
