//
//  FavoritesTests.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/19/24.
//

import XCTest
@testable import AtxHealthInspection

final class FavoritesTests: XCTestCase {
    
    var store: FavoritesStore!
    
    override func setUp() {
        super.setUp()
        store = FavoritesStore()
    }
    
    override func tearDown() {
        super.tearDown()
        store = nil
    }
    
    func testToggleValueAddsToFavorites() async {
        let report = Report.test
        await store.toggleValue(report: report)
        let values = await store.getValues()
        XCTAssertEqual(values["123"], "Test Restaurant")
    }
    
    func testRemoveFavorite() async throws {
        let report = Report.test
        await store.toggleValue(report: report)
        await store.toggleValue(report: report)
        let isFavorite = await store.getValues().values.contains("Test Restaurant")
        XCTAssertFalse(isFavorite, "Expected 'test-id' to be removed from favorites.")
    }
}
