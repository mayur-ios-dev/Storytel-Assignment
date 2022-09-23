//
//  Storytel_AssignmentTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-16.
//

import XCTest
@testable import Storytel_Assignment
import SnapshotTesting
import Combine

final class QueryResultsViewControllerSnapshotTests: XCTestCase {
    
    private var viewController: QueryResultsViewController!
    private var viewModel: MockViewModel!

    override func tearDownWithError() throws {
        viewController = nil
        viewModel = nil
    }
    
    func testViewLoadedState() {
        viewModel = MockViewModel(
            numberOfSections: 3,
            queryString: "Harry Potter",
            rowsInSection: [1, 0, 1]
        )
        viewController = QueryResultsViewController(viewModel: viewModel)
        
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testTenRecordsLoadedState() {
        viewModel = MockViewModel(
            numberOfSections: 3,
            queryString: "Harry Potter",
            rowsInSection: [1, 10, 1]
        )
        viewController = QueryResultsViewController(viewModel: viewModel)
        
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testBatchOfSixRecordsLoading() {
        viewModel = MockViewModel(
            numberOfSections: 3,
            queryString: "Harry Potter",
            rowsInSection: [1, 6, 1]
        )
        viewController = QueryResultsViewController(viewModel: viewModel)
        
        assertSnapshot(matching: viewController, as: .image)
        
        XCTAssertTrue(viewModel.inputs.count > 0)
        
        viewModel.rowsInSection = [1, 12, 1]
        viewModel.output.send(.newDataAdded(startIndex: 6, count: 6))
        
        assertSnapshot(matching: viewController, as: .image)
    }
}

private class MockViewModel: QueryResultsViewModelType {
    var numberOfSections: Int
    var queryString: String
    var rowsInSection: [Int]
    
    var output = PassthroughSubject<QueryResultsViewModel.Output, Never>()
    var inputs: [QueryResultsViewModel.Input] = []
    private var subscriptions = Set<AnyCancellable>()
    
    init(numberOfSections: Int,
         queryString: String,
         rowsInSection: [Int]) {
        self.numberOfSections = numberOfSections
        self.queryString = queryString
        self.rowsInSection = rowsInSection
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        rowsInSection[section]
    }
    
    func queryResult(at index: Int) throws -> Storytel_Assignment.QueryResultCellModel {
        QueryResultCellModel(
            image: Just(
                UIImage.image(
                    with: .blue,
                    size: .init(width: 400, height: 600)
                )
            ).tryMap { $0 }
            .eraseToAnyPublisher(),
            bookTitle: "\(index). Harry Potter and The Prisoner of Azkaban",
            authors: "by J.K. Rowling",
            narrators: "with M.D Deshmukh"
        )
    }
    
    func map(_ input: AnyPublisher<QueryResultsViewModel.Input, Never>) -> AnyPublisher<QueryResultsViewModel.Output, Never> {
        input.sink { [weak self] in
            self?.inputs.append($0)
        }.store(in: &subscriptions)
        return output.eraseToAnyPublisher()
    }
}
