//
//  ApiQueryRequest.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-19.
//

import Foundation

struct ApiQueryRequest {
    let query: String
    let filter: String?
    let store: String
    let nextPageToken: String?
}

extension ApiQueryRequest: UrlRequestBuildable {
    var baseUrlPath: String { "https://api.storytel.net" }
    
    var path: String { "/search/client" }
    
    var method: HTTPMethod { .get }
    
    var queryParameters: [String : String] {
        var queryParameters = [
            "query": query,
            "store": store
        ]
        if let filter = filter {
            queryParameters["searchFor"] = filter
        }
        if let nextPageToken = nextPageToken {
            queryParameters["page"] = nextPageToken
        }
        return queryParameters
    }
}
