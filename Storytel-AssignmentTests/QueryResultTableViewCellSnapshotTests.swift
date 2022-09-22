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
import Combine

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
    
    func testShortTextsWithNoImage() {
        let passthroughSubject = PassthroughSubject<UIImage, Error>()
        let queryResult = QueryResultCellModel(
            image: passthroughSubject.eraseToAnyPublisher(),
            bookTitle: "Harry Potter",
            authors: "JK Rowling",
            narrators: "Mayur Deshmukh"
        )
        view.set(queryResult: queryResult)
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
    
    func testLongTextsWithNoImage() {
        let passthroughSubject = PassthroughSubject<UIImage, Error>()
        let queryResult = QueryResultCellModel(
            image: passthroughSubject.eraseToAnyPublisher(),
            bookTitle: "Harry Potter and the Philosopher's stone (Kid's edition)",
            authors: "JK Rowling, JK Rowling, JK Rowling, JK Rowling, JK Rowling",
            narrators: "Mayur Deshmukh, Mayur Deshmukh, Mayur Deshmukh, Mayur Deshmukh"
        )
        view.set(queryResult: queryResult)
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
    
    func testPortraitImage() {
        let passthroughSubject = PassthroughSubject<UIImage, Error>()
        let queryResult = QueryResultCellModel(
            image: passthroughSubject.eraseToAnyPublisher(),
            bookTitle: "Harry Potter",
            authors: "JK Rowling",
            narrators: "Mayur Deshmukh"
        )
        view.set(queryResult: queryResult)
        
        let image = UIImage.image(with: .green, size: .init(width: 400, height: 600))
        passthroughSubject.send(image)
        
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
    
    func testLandscapeImage() {
        let passthroughSubject = PassthroughSubject<UIImage, Error>()
        let queryResult = QueryResultCellModel(
            image: passthroughSubject.eraseToAnyPublisher(),
            bookTitle: "Harry Potter",
            authors: "JK Rowling",
            narrators: "Mayur Deshmukh"
        )
        view.set(queryResult: queryResult)
        
        let image = UIImage.image(with: .green, size: .init(width: 600, height: 400))
        passthroughSubject.send(image)
        
        assertSnapshot(matching: view.resizedContentViewForSnapshotTest, as: .image)
    }
    
    func testPrepareForReuse() {
        let passthroughSubject = PassthroughSubject<UIImage, Error>()
        let queryResult = QueryResultCellModel(
            image: passthroughSubject.eraseToAnyPublisher(),
            bookTitle: "Harry Potter",
            authors: "JK Rowling",
            narrators: "Mayur Deshmukh"
        )
        view.set(queryResult: queryResult)
        
        view.prepareForReuse()
        
        let image = UIImage.image(with: .green, size: .init(width: 600, height: 400))
        passthroughSubject.send(image)
        
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
