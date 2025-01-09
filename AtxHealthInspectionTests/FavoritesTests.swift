//
//  FavoritesTests.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/19/24.
//

import XCTest
@testable import AtxHealthInspection

final class FavoritesTests: XCTestCase {
    
    var mgr: FavoritesManager!
    
    override func setUp() {
        super.setUp()
        mgr = FavoritesManager()
    }
    
    override func tearDown() {
        super.tearDown()
        mgr = nil
    }
    
    func testToggleValueAddsToFavorites() async {
        let report = Report.test
        await mgr.toggleValue(report: report)
        let values = await mgr.getValues()
        XCTAssertEqual(values["123"], "Test Restaurant")
    }
    
    func testRemoveFavorite() async throws {
        let report = Report.test
        await mgr.toggleValue(report: report)
        await mgr.toggleValue(report: report)
        let isFavorite = await mgr.getValues().values.contains("Test Restaurant")
        XCTAssertFalse(isFavorite, "Expected 'test-id' to be removed from favorites.")
    }
}
