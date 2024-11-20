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
    
    func testAddFavorite() async throws {
        await mgr.toggleValue(id: "test-id")
        let isFavorite = await mgr.getValues().contains("test-id")
        XCTAssertTrue(isFavorite, "Expected 'test-id' to be a favorite.")
    }
    
    func testRemoveFavorite() async throws {
        await mgr.toggleValue(id: "test-id")
        await mgr.toggleValue(id: "test-id")
        let isFavorite = await mgr.getValues().contains("test-id")
        XCTAssertFalse(isFavorite, "Expected 'test-id' to be removed from favorites.")
    }
}
