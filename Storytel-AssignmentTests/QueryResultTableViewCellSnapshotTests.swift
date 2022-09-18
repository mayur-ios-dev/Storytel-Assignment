//
//  QueryResultTableViewCellSnapshotTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-18.
//

import XCTest
@testable import Storytel_Assignment
import SnapshotTesting
import Foundation

final class QueryResultTableViewCellSnapshotTests: XCTestCase {
    var view: QueryResultTableViewCell!
    
    override func setUpWithError() throws {
        view = QueryResultTableViewCell(frame: .zero)
    }

    override func tearDownWithError() throws {
        view = nil
    }
    
    func testLoadedState() {
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
}

extension UITableViewCell {
    var resizedContentViewForSnapshotTest: UIView {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        return contentView
    }
}
