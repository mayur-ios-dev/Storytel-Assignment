//
//  Storytel_AssignmentTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-16.
//

import XCTest
@testable import Storytel
import SnapshotTesting
import Combine

final class QueryResultsViewControllerSnapshotTests: XCTestCase {
    
    private var viewController: QueryResultsViewController<MockViewModel>!
    private var viewModel: MockViewModel!
    
    override func tearDownWithError() throws {
        viewController = nil
        viewModel = nil
    }
    
    func testViewLoadedState() {
        viewModel = MockViewModel(
            query: "Harry Potter",
            hasItemsToLoad: true,
            numberOfItems: 0
        )
        viewController = QueryResultsViewController(viewModel: viewModel)
        
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testTenRecordsLoadedState() {
        viewModel = MockViewModel(
            query: "Harry Potter",
            hasItemsToLoad: true,
            numberOfItems: 10
        )
        viewController = QueryResultsViewController(viewModel: viewModel)
        
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testBatchOfSixRecordsLoading() {
        viewModel = MockViewModel(
            query: "Harry Potter",
            hasItemsToLoad: true,
            numberOfItems: 6
        )
        viewController = QueryResultsViewController(viewModel: viewModel)
        
        assertSnapshot(matching: viewController, as: .image)
        
        XCTAssertTrue(viewModel.loadCount > 0)
        
        viewModel.rowsInSection = [1, 12, 1]
        viewModel.output.send(.newDataAdded(startIndex: 6, count: 6))
        
        assertSnapshot(matching: viewController, as: .image)
    }
}
/*
 private class MockViewModel: QueryResultsViewModelType {
 var numberOfSections: Int
 var queryString: String
 var rowsInSection: [Int]
 
 var output = PassthroughSubject<QueryResultsViewModel.Output, Never>()
 var inputs: [QueryResultsViewModel.Input] = []
 private var subscriptions = [AnyCancellable]()
 
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
 
 func queryResult(at index: Int) throws -> QueryResultCellModel {
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
 */

private class MockViewModel: QueryResultTableViewModelType {
    var newData: AnyPublisher<(startIndex: Int, count: Int), Never> = PassthroughSubject().eraseToAnyPublisher()
    var query: String
    var hasItemsToLoad: Bool
    var items: [QueryResultItem]
    var loadCount = 0
    
    init(query: String, hasItemsToLoad: Bool, numberOfItems: Int) {
        self.query = query
        self.hasItemsToLoad = hasItemsToLoad
        setItemCount(numberOfItems)
    }
    
    func setItemCount(_ numberOfItems: Int) {
        items = stride(from: 1, to: numberOfItems, by: 1).map {
            .init(
                imageUrl: "",
                title: "\($0). Harry Potter and The Prisoner of Azkaban",
                authors: "by J.K. Rowling",
                narrators: "with M.D Deshmukh"
            )
        }
    }
    
    func queryCellModel(at index: Int) throws -> QueryResultCellModel {
        guard index < items.count else {
            throw QueryResultViewModelError.indexOutOfBound
        }
        let item = items[index]
        
        return QueryResultCellModel(
            image: Just(
                UIImage.image(
                    with: .blue,
                    size: .init(width: 400, height: 600)
                )
            ).tryMap { $0 }
                .eraseToAnyPublisher(),
            bookTitle: item.title,
            authors: item.authors,
            narrators: item.narrators
        )
    }
    
    func loadData() {
        loadCount += 1
    }
}
