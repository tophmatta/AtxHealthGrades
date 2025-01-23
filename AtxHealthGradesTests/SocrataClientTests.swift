//
//  SocrataClientTests.swift
//  AtxHealthGradesTests
//
//  Created by Toph Matta on 7/7/24.
//

import XCTest
@testable import AtxHealthGrades

final class SocrataClientTests: XCTestCase {

    var mockClient: SocrataClientProtocol!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        mockClient = SocrataAPIClient(client: APIClient(session: session))
    }
    
    override func tearDown() {
        mockClient = nil
        super.tearDown()
    }
    
    func testGetWithValidInput() async throws {
        let data = mockContentData

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        do {
            let result = try await mockClient.search(byName: "The 04 Lounge")
            XCTAssertFalse(result.isEmpty, "Result should not be empty")
        } catch {
            XCTFail("Expected success, but got failure with error: \(error)")
        }
    }
    
    func testGetWithInvalidInput() async throws {
        let data = emptyData
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        do {
            _ = try await mockClient.search(byName: "!@#$%^&*")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyTextSearchResponse)
        } catch {
            XCTFail("Expected ClientError.emptyTextSearchResponse, but got unexpected error: \(error)")
        }
    }
    
    func testGetWithEmptyInput() async throws {
        do {
            _ = try await mockClient.search(byName: "")
            XCTFail("Expected failure for empty input, but got success")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyInputValue)
        } catch {
            XCTFail("Expected ClientError.emptyInputValue, but got unexpected error: \(error)")
        }
    }
    
    func testGetWithBlankInput() async throws {
        do {
            _ = try await mockClient.search(byName: "    ")
            XCTFail("Expected failure for blank input, but got success")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyInputValue)
        } catch {
            XCTFail("Expected ClientError.emptyInputValue, but got unexpected error: \(error)")
        }
    }
    
    func testGetWithNonexistantPlace() async throws {
        let data = emptyData

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        do {
            _ = try await mockClient.search(byName: "Casa Bonita de Toph")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyTextSearchResponse)
        } catch {
            XCTFail("Expected ClientError.emptyTextSearchResponse, but got unexpected error: \(error)")
        }
    }
}

extension XCTestCase {
    var mockContentData: Data {
        getData(name: "test04loungedata")
    }
    
    var emptyData: Data {
        "".data(using: .utf8)!
    }

    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
