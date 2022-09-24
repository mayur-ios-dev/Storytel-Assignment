//
//  QueryResultsViewModelTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-23.
//

import XCTest
@testable import Storytel
import Combine

final class QueryResultsViewModelTests: XCTestCase {
    private var viewModel: QueryResultsViewModel!
    private var api: MockApiService!
    private var imageLoader: MockImageLoader!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        api = MockApiService()
        viewModel = QueryResultsViewModel(
            queryMetadata: .init(
                query: "Harry",
                filter: .narrators,
                store: "STHP-SE"
            ),
            api: api
        )
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        api = nil
        imageLoader = nil
    }
    
    func testOnDisplayingLoadingSectionMakesApiCall() throws {
        let input = PassthroughSubject<QueryResultsViewModel.Input, Never>()
        let outputExpectation = expectation(description: "Output Expectation")
        viewModel
            .map(input.eraseToAnyPublisher())
            .sink { output in
                guard case .newDataAdded = output else {
                    return XCTFail()
                }
                outputExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        input.send(.willDisplayCell(at: .init(row: 0, section: 2)))
        
        XCTAssertEqual(api.query, "Harry")
        XCTAssertEqual(api.store, "STHP-SE")
        XCTAssertEqual(api.filter, .narrators)
        XCTAssertEqual(api.nextPageToken, nil)
        
        api.output.send(.mock(nextPageToken: "123", totalCount: 4))
        
        XCTAssertEqual(viewModel.numberOfSections, 3)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 1), 2)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), 1)
        
        let queryResult = try viewModel.queryResult(at: 0)
        
        XCTAssertEqual(queryResult.bookTitle, "test Title1")
        
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), 1)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testAppendingItemsAndUpdatedNextPageToken() {
        let input = PassthroughSubject<QueryResultsViewModel.Input, Never>()
        viewModel
            .map(input.eraseToAnyPublisher())
            .sink { output in
                guard case .newDataAdded = output else {
                    return XCTFail()
                }
            }
            .store(in: &subscriptions)
        
        // First loading
        input.send(.willDisplayCell(at: .init(row: 0, section: 2)))
        
        XCTAssertEqual(api.query, "Harry")
        XCTAssertEqual(api.store, "STHP-SE")
        XCTAssertEqual(api.filter, .narrators)
        XCTAssertEqual(api.nextPageToken, nil)
        
        api.output.send(.mock(nextPageToken: "123", totalCount: 4))
        api.output.send(completion: .finished)
        
        XCTAssertEqual(viewModel.numberOfSections, 3)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 1), 2)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), 1)
        
        api.output = PassthroughSubject<ApiQueryResult, Error>()
        input.send(.willDisplayCell(at: .init(row: 0, section: 2)))
        
        XCTAssertEqual(api.query, "Harry")
        XCTAssertEqual(api.store, "STHP-SE")
        XCTAssertEqual(api.filter, .narrators)
        XCTAssertEqual(api.nextPageToken, "123")
        
        
        api.output.send(.mock(nextPageToken: "456", totalCount: 4))
        
        XCTAssertEqual(viewModel.numberOfSections, 3)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 1), 4)
        XCTAssertEqual(viewModel.numberOfRows(inSection: 2), 0, "Loading cell shown even though all items were loaded")
    }
    
    func testNotDisplayingLoadingSectionDoesNotMakeApiCall() {
        let input = PassthroughSubject<QueryResultsViewModel.Input, Never>()
        viewModel
            .map(input.eraseToAnyPublisher())
            .sink { output in
                guard case .newDataAdded = output else {
                    return XCTFail()
                }
            }
            .store(in: &subscriptions)
        
        input.send(.willDisplayCell(at: .init(row: 0, section: 0)))
        input.send(.willDisplayCell(at: .init(row: 0, section: 1)))
        input.send(.willDisplayCell(at: .init(row: 1, section: 1)))
        
        XCTAssertEqual(api.query, nil)
        XCTAssertEqual(api.store, nil)
        XCTAssertEqual(api.filter, nil)
        XCTAssertEqual(api.nextPageToken, nil)
        
        api.output.send(.mock(nextPageToken: "123", totalCount: 4))
    }
}

private class MockApiService: ApiQueryServiceType {
    var output = PassthroughSubject<ApiQueryResult, Error>()
    var query: String?
    var filter: QueryMetadataModel.SearchFilter?
    var store: String?
    var nextPageToken: String?
    
    func search(_ query: String,
                filter: QueryMetadataModel.SearchFilter?,
                store: String,
                nextPageToken: String?) throws -> AnyPublisher<ApiQueryResult, Error> {
        self.query = query
        self.filter = filter
        self.store = store
        self.nextPageToken = nextPageToken
        return output.eraseToAnyPublisher()
    }
}

private class MockImageLoader: ApiImageLoaderServiceType {
    var urlString: String?
    private var output = PassthroughSubject<UIImage, Error>()
    
    func image(withUrlString urlString: String?) -> AnyPublisher<UIImage, Error> {
        self.urlString = urlString
        return output.eraseToAnyPublisher()
    }
}

private extension ApiQueryResult {
    static func mock(nextPageToken: String, totalCount: Int) -> ApiQueryResult {
        .init(
            query: "Harry",
            filter: "narrator",
            nextPageToken: nextPageToken,
            totalCount: totalCount,
            items: [
                .init(
                    id: "testId1",
                    title: "test Title1",
                    authors: [],
                    narrators: [],
                    formats: []
                ),
                .init(
                    id: "testId2",
                    title: "test Title2",
                    authors: [],
                    narrators: [],
                    formats: []
                )
            ]
        )
    }
}
