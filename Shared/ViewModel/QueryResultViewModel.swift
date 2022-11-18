//
//  QueryResultViewModel.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import Combine
import UIKit

protocol QueryResultViewModelType: ObservableObject {
    var query: String { get }
    var items: [QueryResultItem] { get }
    var hasItemsToLoad: Bool { get }
    func loadData()
}

final class QueryResultViewModel: QueryResultViewModelType {
    private var queryMetadata: QueryMetadataModel
    private var api: ApiQueryServiceType
    private var imageLoader: ApiImageLoaderServiceType
    
    private var isLoading = false
    
    private var subscriptions = [AnyCancellable]()
    
    @Published private var queryResult: ApiQueryResult?
    
    init(queryMetadata: QueryMetadataModel,
         api: ApiQueryServiceType = ApiQueryService(),
         imageLoader: ApiImageLoaderServiceType = ApiImageLoaderService()) {
        self.queryMetadata = queryMetadata
        self.api = api
        self.imageLoader = imageLoader
    }
    
    var query: String {
        queryMetadata.query
    }
    
    var hasItemsToLoad: Bool {
        queryResult.hasMoreItemsToLoad
    }
    
    func loadData() {
        guard !isLoading, queryResult.hasMoreItemsToLoad else { return }
        isLoading = true
        do {
            try api.search(
                queryMetadata.query,
                filter: queryMetadata.filter,
                store: queryMetadata.store,
                nextPageToken: queryResult?.nextPageToken
            )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
                // log error
            }, receiveValue: { [weak self] newQueryResult in
                self?.queryResult = self?.queryResult.appending(newQueryResult)
            }).store(in: &subscriptions)
        } catch {
            // log error
        }
    }
    
    var items: [QueryResultItem] {
        guard let queryResult = queryResult else { return [] }
        return queryResult.items.map {
            QueryResultItem(
                imageUrl: $0.formats.first?.cover.url ?? "",
                title: $0.title,
                authors: $0.byAuthors,
                narrators: $0.withNarrators
            )
        }
    }
}

//MARK: - QueryResultTableViewModelType

struct QueryResultCellModel {
    var image: AnyPublisher<UIImage, Error>
    var bookTitle: String
    var authors: String
    var narrators: String
}

protocol QueryResultTableViewModelType: QueryResultViewModelType {
    var newData: AnyPublisher<(startIndex: Int, count: Int), Never> { get }
    func queryCellModel(at index: Int) throws -> QueryResultCellModel
}

extension QueryResultTableViewModelType {
    var numberOfSections: Int { 3 }
    
    func numberOfRows(inSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return items.count
        case 2: return hasItemsToLoad ? 1 : 0
        default : return 0
        }
    }
}

extension QueryResultViewModel: QueryResultTableViewModelType {
    var newData: AnyPublisher<(startIndex: Int, count: Int), Never> {
        return $queryResult
            .receive(on: RunLoop.main)
            .map { $0?.items.count ?? 0 }
            .withPrevious() // Take previous and current item count
            .map { return ($0.previous ?? 0, $0.current ) }
            .filter { $0 < $1 } // Filter out if previous count is not less than current count
            .map { ($0, $1 - $0 ) } // Map to start index and count of new Data
            .eraseToAnyPublisher()
    }
    
    func queryCellModel(at index: Int) throws -> QueryResultCellModel {
        guard index < items.count else {
            throw QueryResultViewModelError.indexOutOfBound
        }
        let item = items[index]
        
        return QueryResultCellModel(
            image: try image(at: index)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher(),
            bookTitle: item.title,
            authors: item.authors,
            narrators: item.narrators
        )
    }
    
    private func image(at index: Int) throws -> AnyPublisher<UIImage, Error> {
        guard index < items.count else {
            throw QueryResultViewModelError.indexOutOfBound
        }
        let item = items[index]
        return imageLoader.image(withUrlString: item.imageUrl)
    }
}

// MARK: - QueryResultViewModelError
enum QueryResultViewModelError: Error {
    case indexOutOfBound
}
