//
//  ApiQueryService.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-19.
//

import Foundation
import Combine

protocol ApiQueryServiceType {
    func search(_ query: String,
                filter: QueryMetadataModel.SearchFilter?,
                store: String,
                nextPageToken: String?) throws -> AnyPublisher<ApiQueryResult, Error>
}

final class ApiQueryService {
    private var session: URLSessionType
    
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

extension ApiQueryService: ApiQueryServiceType {
    func search(_ query: String,
                filter: QueryMetadataModel.SearchFilter?,
                store: String,
                nextPageToken: String?) throws -> AnyPublisher<ApiQueryResult, Error> {
        let queryRequest = ApiQueryRequest(
            query: query,
            filter: filter?.rawValue,
            store: store,
            nextPageToken: nextPageToken
        )
        return session
            .dataTaskPublisher(for: try queryRequest.request)
            .tryMap {
                guard let response = $1 as? HTTPURLResponse else {
                    throw URLError(
                        .badServerResponse,
                        userInfo: [
                            "reason": "Not a HTTPURLResponse: \($1)"
                        ]
                    )
                }
                guard response.statusCode == 200 else {
                    throw URLError(
                        .badServerResponse,
                        userInfo: [
                            "reason": "Unexpected statuscode \(response.statusCode)"
                        ]
                    )
                }
                return $0
            }
            .decode(type: ApiQueryResult.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
