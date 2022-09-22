//
//  QueryLoaderTableViewCellSnapshotTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-22.
//

import XCTest
@testable import Storytel_Assignment
import SnapshotTesting

final class QueryLoaderTableViewCellSnapshotTests: XCTestCase {

    var view: QueryLoaderTableViewCell!
    
    override func setUpWithError() throws {
        view = QueryLoaderTableViewCell(frame: .zero)
    }

    override func tearDownWithError() throws {
        view = nil
    }

    func testLoadedState() {
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
}
