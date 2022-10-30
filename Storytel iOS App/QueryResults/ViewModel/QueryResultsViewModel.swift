//
//  QueryResultsViewModel.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-21.
//

import Foundation
import Combine
import UIKit

protocol QueryResultsViewModelType {
    var numberOfSections: Int { get }
    func numberOfRows(inSection section: Int) -> Int
    var queryString: String { get }
    func queryResult(at index: Int) throws -> QueryResultCellModel
    
    func map(_ input: AnyPublisher<QueryResultsViewModel.Input, Never>) -> AnyPublisher<QueryResultsViewModel.Output, Never>
}

final class QueryResultsViewModel {
    private var queryMetadata: QueryMetadataModel
    private var api: ApiQueryServiceType
    private var imageLoader: ApiImageLoaderServiceType
    
    private var output = PassthroughSubject<Output, Never>()
    
    private var queryResult: ApiQueryResult?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(queryMetadata: QueryMetadataModel,
         api: ApiQueryServiceType = ApiQueryService(),
         imageLoader: ApiImageLoaderServiceType = ApiImageLoaderService()) {
        self.queryMetadata = queryMetadata
        self.api = api
        self.imageLoader = imageLoader
    }
}

// MARK: - QueryResultsViewModelType
extension QueryResultsViewModel: QueryResultsViewModelType {
    var numberOfSections: Int { 3 }
    
    func numberOfRows(inSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return queryResult?.items.count ?? 0
        case 2: return queryResult.hasMoreItemsToLoad ? 1 : 0
        default : return 0
        }
    }
    
    var queryString: String { queryMetadata.query }
    
    func queryResult(at index: Int) throws -> QueryResultCellModel {
        guard let items = queryResult?.items else {
            throw QueryResultsViewModelError.queryResultsRequestedWhenNotLoaded
        }
        guard index < items.count else {
            throw QueryResultsViewModelError.indexOutOfBound
        }
        return queryResultCellModel(from: items[index])
    }
    
    func map(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] receivedInput in
            switch receivedInput {
            case .willDisplayCell(at: let indexPath):
                guard indexPath.section == 2 else { return }
                self?.getResults()
            }
        }.store(in: &subscriptions)
        return output
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

private extension QueryResultsViewModel {
    func getResults() {
        guard queryResult.hasMoreItemsToLoad else { return }
        do {
            try api.search(
                queryMetadata.query,
                filter: queryMetadata.filter,
                store: queryMetadata.store,
                nextPageToken: queryResult?.nextPageToken
            ).sink(receiveCompletion: { _ in
                // log error
            }, receiveValue: { [weak self] newQueryResult in
                self?.handle(newQueryResult: newQueryResult)
            }).store(in: &subscriptions)
        } catch {
            // log error
        }
    }
    
    func handle(newQueryResult: ApiQueryResult) {
        let updatedQueryResult = queryResult.appending(newQueryResult)
        guard newQueryResult.items.count > 0 else { return }
        let startIndexOfNewItems = queryResult?.items.count ?? 0
        queryResult = updatedQueryResult
        output.send(
            .newDataAdded(startIndex: startIndexOfNewItems, count: newQueryResult.items.count)
        )
    }
    
    func queryResultCellModel(from item: ApiQueryResult.Item) -> QueryResultCellModel {
        QueryResultCellModel(
            image: imageLoader.image(
                withUrlString: item.formats.first?.cover.url
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher(),
            bookTitle: item.title,
            authors: item.byAuthors,
            narrators: item.withNarrators
        )
    }
}

// MARK: - Input and Output
extension QueryResultsViewModel {
    enum Input {
        case willDisplayCell(at: IndexPath)
    }
    
    enum Output {
        case newDataAdded(startIndex: Int, count: Int)
    }
}

// MARK: - QueryResultsViewModelError
enum QueryResultsViewModelError: Error {
    case indexOutOfBound
    case queryResultsRequestedWhenNotLoaded
}
