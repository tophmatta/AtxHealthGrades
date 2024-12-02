//
//  SocrataClientTests.swift
//  AtxHealthInspectionTests
//
//  Created by Toph Matta on 7/7/24.
//

import XCTest
@testable import AtxHealthInspection

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
    
    func testGetWithEmptyInput() async throws {
        do {
            _ = try await mockClient.search(byName: "")
            XCTFail("Expected failure for empty input, but got success")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyValue)
        } catch {
            XCTFail("Expected ClientError.emptyValue, but got unexpected error: \(error)")
        }
    }
    
    func testGetWithBlankInput() async throws {
        do {
            _ = try await mockClient.search(byName: "    ")
            XCTFail("Expected failure for blank input, but got success")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyValue)
        } catch {
            XCTFail("Expected ClientError.emptyValue, but got unexpected error: \(error)")
        }
    }
    
    func testGetWithNonexistantPlace() async throws {
        let data = mockContentData

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        do {
            _ = try await mockClient.search(byName: "Casa Bonita de Toph")
        } catch let error as ClientError {
            XCTAssertEqual(error, .emptyResponse)
        } catch {
            XCTFail("Expected ClientError.emptyValue, but got unexpected error: \(error)")
        }
    }
}

extension XCTestCase {
    var mockContentData: Data {
        return getData(name: "test04loungedata")
    }

    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
