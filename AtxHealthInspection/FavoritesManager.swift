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
    
    func toggleValue(id: String) {
        if getValues().contains(id) {
            remove(id)
        } else {
            add(id)
        }
    }
    
    private func add(_ id: String) {
        var values = getValues()
        values.insert(id)
        persist(values)
    }
    
    private func remove(_ id: String) {
        var values = getValues()
        values.remove(id)
        persist(values)
    }
    
    private func persist(_ favoriteIDs: Set<String>) {
        defaults.set(Array(favoriteIDs), forKey: UserDefaultsKeys.favoriteIDs)
    }
    
    func getValues() -> Set<String> {
        let array = defaults.array(forKey: UserDefaultsKeys.favoriteIDs) as? [String] ?? []
        return Set(array)
    }
}

private struct UserDefaultsKeys {
    static let favoriteIDs = "favoriteIDs"
}
