//
//  InputTests.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 10/18/24.
//

import XCTest
@testable import AtxHealthGrades

final class InputTests: XCTestCase {
    func testEmptyString() {
        let input = ""
        let expected = ""
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }

    func testTrimWithBlank() {
        let input = "   "
        let expected = ""
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleWordsWithPrefixAndApostrophe() {
        let input = "The Vincent's Restaurant"
        let expected = "vincent%restaurant"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testOneWordWithApostrophe() {
        let input = "Amy's "
        let expected = "amy"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testLazyNoApostrophe() {
        let input = "Torchys"
        let expected = "torchy"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testWordWithPunctuationAndLazyNoApostrophe() {
        let input = "P. Terrys"
        let expected = "p%terry"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleWordsWithOneApostrophe() {
        let input = "Fat Daddy's Chicken "
        let expected = "fat%daddy%chicken"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testAllCaps() {
        let input = "ATX Cocina"
        let expected = "atx%cocina"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleApostrophes() {
        let input = "John's and Mary's"
        let expected = "john%and%mary"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
            
    func testMultipleWhitespaces() {
        let input = "Hello   World"
        let expected = "hello%world"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
    
    func testPunctuationOtherThanApostrophes() {
        let input = "P. Terry's, Inc."
        let expected = "p%terry%inc"
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }
        
    func testOnlySpecialCharacters() {
        let input = "!!@#$%%@"
        let expected = ""
        let result = input.prepForQuery()
        XCTAssertEqual(result, expected)
    }    
}
