//
//  QueryModel.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-22.
//

import Foundation

struct QueryMetadataModel {
    let query: String
    let filter: SearchFilter?
    let store: String
    
    enum SearchFilter: String {
        case books
        case booksAndEpisode = "books_and_episodes"
        case authors
        case narrators
        case tags
        case series
    }
}
