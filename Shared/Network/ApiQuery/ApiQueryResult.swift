//
//  ApiQueryResult.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-19.
//

import Foundation

struct ApiQueryResult: Decodable {
    let query: String
    let filter: String
    let nextPageToken: String
    let totalCount: Int
    let items: [Item]
    
    struct Item: Decodable {
        let id: String
        let title: String
        let authors: [Author]
        let narrators: [Narrator]
        let formats: [Format]
        
        struct Author: Decodable {
            let id: String
            let name: String
        }
        
        struct Narrator: Decodable {
            let id: String
            let name: String
        }
        
        struct Format: Decodable {
            let id: String
            let type: String
            let cover: Cover
            
            struct Cover: Decodable {
                let url: String
                let width: Int
                let height: Int
            }
        }
    }
}

// MARK: - ApiQueryResult Helpers

extension ApiQueryResult.Item {
    var byAuthors: String {
        "by " + authors.map{ $0.name }.joined(separator: ", ")
    }
    
    var withNarrators: String {
        "with " + narrators.map{ $0.name }.joined(separator: ", ")
    }
}

extension Optional where Wrapped == ApiQueryResult {
    func appending(_ apiQueryResult: ApiQueryResult) -> Self {
        guard let self = self else { return apiQueryResult }
        
        return ApiQueryResult(
            query: apiQueryResult.query,
            filter: apiQueryResult.filter,
            nextPageToken: apiQueryResult.nextPageToken,
            totalCount: apiQueryResult.totalCount,
            items: self.items + apiQueryResult.items
        )
    }
    
    var hasMoreItemsToLoad: Bool {
        guard let self = self else { return true }
        return self.items.count < self.totalCount
    }
}
