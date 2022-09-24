//
//  QueryHeaderTableViewCellSnapshotTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-22.
//

import XCTest
@testable import Storytel
import SnapshotTesting

final class QueryHeaderTableViewCellSnapshotTests: XCTestCase {
    var view: QueryHeaderTableViewCell!
    
    override func setUpWithError() throws {
        view = QueryHeaderTableViewCell(frame: .zero)
    }

    override func tearDownWithError() throws {
        view = nil
    }

    func testLoadedState() {
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
    
    func testShortText() {
        view.set(query: "Short query")
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
    
    func testLongText() {
        view.set(query: "This is a very very long query")
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }

}
