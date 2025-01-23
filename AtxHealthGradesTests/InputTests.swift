//
//  InputTests.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 10/18/24.
//

import XCTest
@testable import AtxHealthGrades

final class InputTests: XCTestCase {
    
    func testTrimWithBlank() {
        let input = "   "
        let expected = ""
        let result = input.trimForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleWordsWithPrefixAndApostrophe() {
        let input = "The Vincent's Restaurant"
        let expected = "vincent restaurant"
        let result = input.trimForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testOneWordWithApostrophe() {
        let input = "Amy's "
        let expected = "amy"
        let result = input.trimForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleWordsWithOneApostrophe() {
        let input = "Fat Daddy's Chicken "
        let expected = "fat daddy chicken"
        let result = input.trimForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testAllCaps() {
        let input = "ATX Cocina"
        let expected = "atx cocina"
        let result = input.trimForQuery()
        XCTAssertEqual(result, expected)
    }
}
