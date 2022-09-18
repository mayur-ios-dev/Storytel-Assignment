//
//  Storytel_AssignmentTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-16.
//

import XCTest
@testable import Storytel_Assignment
import SnapshotTesting

final class QueryResultsViewControllerSnapshotTests: XCTestCase {
    
    private var viewController: QueryResultsViewController!

    override func setUpWithError() throws {
        viewController = QueryResultsViewController()
    }

    override func tearDownWithError() throws {
        viewController = nil
    }
    
    func testViewLoadedState() {
        assertSnapshot(matching: viewController, as: .image)
    }
}
