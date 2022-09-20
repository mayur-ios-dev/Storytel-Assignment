//
//  ApiQueryRequest.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-19.
//

import Foundation

struct ApiQueryRequest {
    let query: String
    let filter: SearchFilter
    let store: String
    let nextPageToken: String?
    
    enum SearchFilter: String {
        case books
        case booksAndEpisode = "books_and_episodes"
        case authors
        case narrators
        case tags
        case series
    }
}

extension ApiQueryRequest: UrlRequestBuildable {
    var baseUrlPath: String { "https://api.storytel.net" }
    
    var path: String { "/search/client" }
    
    var method: HTTPMethod { .get }
    
    var queryParameters: [String : String] {
        [
            "query": query,
            "searchFor": filter.rawValue,
            "store": store,
            "page": nextPageToken ?? "0"
        ]
    }
}
