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
    
}

// MARK: - Input and Output
extension QueryResultsViewModel {
    enum Input {
        case willDisplayCell(at: IndexPath)
    }
    
    enum Output {
        case dataFetched
    }
}
