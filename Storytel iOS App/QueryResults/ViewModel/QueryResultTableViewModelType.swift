//
//  QueryResultTableViewModelType.swift
//  Storytel
//
//  Created by Mayur Deshmukh on 2022-11-19.
//

import UIKit
import Combine

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
            .receive(on: DispatchQueue.main)
            .map { $0?.items.count ?? 0 }
            .withPrevious() // Take previous and current item count
            .map { return ($0.previous ?? 0, $0.current ) }
            .filter { $0 < $1 } // Filter out if current count is not more than previous count
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
            .receive(on: DispatchQueue.main)
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
