//
//  URLSessionType.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-20.
//

import Foundation

protocol URLSessionType {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}
extension URLSession: URLSessionType {}
