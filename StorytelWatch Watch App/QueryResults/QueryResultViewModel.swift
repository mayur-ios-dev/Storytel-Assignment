//
//  QueryResultViewModel.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import Combine

protocol QueryResultViewModelType: ObservableObject {
    var query: String { get }
    var items: [QueryResultItem] { get }
    var hasItemsToLoad: Bool { get }
    func loadData()
}

final class QueryResultViewModel: QueryResultViewModelType {
    private var queryMetadata: QueryMetadataModel
    private var api: ApiQueryServiceType
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private var queryResult: ApiQueryResult?
    
    init(queryMetadata: QueryMetadataModel, api: ApiQueryServiceType) {
        self.queryMetadata = queryMetadata
        self.api = api
    }
    
    var query: String {
        queryMetadata.query
    }
    
    var hasItemsToLoad: Bool {
        queryResult.hasMoreItemsToLoad
    }
    
    func loadData() {
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
