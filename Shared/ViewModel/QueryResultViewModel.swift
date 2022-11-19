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

final class QueryResultViewModel {
    private var queryMetadata: QueryMetadataModel
    private var api: ApiQueryServiceType
    var imageLoader: ApiImageLoaderServiceType
    
    private var isLoading = false
    
    private var subscriptions = [AnyCancellable]()
    
    @Published var queryResult: ApiQueryResult?
    
    init(queryMetadata: QueryMetadataModel,
         api: ApiQueryServiceType = ApiQueryService(),
         imageLoader: ApiImageLoaderServiceType = ApiImageLoaderService()) {
        self.queryMetadata = queryMetadata
        self.api = api
        self.imageLoader = imageLoader
    }
}

//MARK: - QueryResultViewModelType
extension QueryResultViewModel: QueryResultViewModelType {
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
            .receive(on: DispatchQueue.main)
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
