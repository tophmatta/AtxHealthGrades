//
//  FavoritesManager.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/15/24.
//

import Foundation
import Combine


actor FavoritesManager {
    private let defaults = UserDefaults.standard
    
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
