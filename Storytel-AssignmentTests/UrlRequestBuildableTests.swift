//
//  UrlRequestBuildableTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-20.
//

import XCTest
@testable import Storytel_Assignment
import SnapshotTesting

final class UrlRequestBuildableTests: XCTestCase {
    func testBadBaseUrlPath() {
        let mockData = "MockData".data(using: .utf8)
        let requestBuildable = MockRequestBuildable(
            baseUrlPath: "badBaseUrl^",
            path: "/testPath",
            method: .get,
            queryParameters: ["testKey" : "testValue"],
            httpBody: mockData
        )
        do {
            let urlRequest = try requestBuildable.request
            XCTFail("Request did not throw as expected: \(urlRequest)")
        } catch let error as URLError {
            XCTAssertEqual(error.code, URLError.badURL)
            guard let failureMessage = error.userInfo["failedUrlString"] as? String else {
                return XCTFail("Incorrect failedUrlString")
            }
            XCTAssertEqual(failureMessage, "badBaseUrl^/testPath")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
    
    func testBadPath() {
        let mockData = "MockData".data(using: .utf8)
        let requestBuildable = MockRequestBuildable(
            baseUrlPath: "badBaseUrl",
            path: "/^testPath",
            method: .get,
            queryParameters: ["testKey" : "testValue"],
            httpBody: mockData
        )
        do {
            let urlRequest = try requestBuildable.request
            XCTFail("Request did not throw as expected: \(urlRequest)")
        } catch let error as URLError {
            XCTAssertEqual(error.code, URLError.badURL)
            guard let failureMessage = error.userInfo["failedUrlString"] as? String else {
                return XCTFail("Incorrect failedUrlString")
            }
            XCTAssertEqual(failureMessage, "badBaseUrl/^testPath")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
    
    func testGoodRequest() throws {
        let mockData = "MockData".data(using: .utf8)
        let requestBuildable = MockRequestBuildable(
            baseUrlPath: "https://api.storytel.net",
            path: "/search/client?testKey=testValue",
            method: .post,
            queryParameters: [
                "testKey1" : "testValue1",
                "testKey2" : "testValue2"
            ],
            httpBody: mockData
        )
        let urlRequest = try requestBuildable.request
        assertSnapshot(matching: urlRequest, as: .dump)
    }
}

private struct MockRequestBuildable: UrlRequestBuildable {
    let baseUrlPath: String
    let path: String
    let method: HTTPMethod
    let queryParameters: [String: String]
    let httpBody: Data?
}
