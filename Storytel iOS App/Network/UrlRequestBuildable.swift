//
//  UrlRequestBuildable.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-19.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol UrlRequestBuildable {
    var baseUrlPath: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    var queryParameters: [String: String] { get }
    var httpBody: Data? { get }
    
    var request: URLRequest { get throws }
}

extension UrlRequestBuildable {
    var queryParameters: [String: String] { [:] }
    var httpBody: Data? { nil }
    
    var request: URLRequest {
        get throws {
            let urlString = baseUrlPath + path
            guard let url = URL(string: urlString),
                  var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw URLError(
                    .badURL,
                    userInfo: [
                        "failedUrlString": urlString
                    ]
                )
            }
            
            var queryItems = queryParameters.map {
                URLQueryItem(name: $0, value: $1)
            }
            if let queryParametesInUrlString = urlComponents.queryItems {
                queryItems.append(contentsOf: queryParametesInUrlString)
            }
            
            // Consistent sequence for testing. Else testing would be more complicated
            urlComponents.queryItems = queryItems.sorted { $0.name < $1.name}
            
            guard let url = urlComponents.url else {
                throw URLError(
                    .badURL,
                    userInfo: [
                        "failedQueryParameters": queryParameters
                    ]
                )
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue.uppercased()
            request.httpBody = httpBody
            
            return request
        }
    }
}
