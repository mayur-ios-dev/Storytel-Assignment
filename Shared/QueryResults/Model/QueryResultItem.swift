//
//  QueryResultItem.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import Foundation

struct QueryResultItem {
    var imageUrl: String
    var title: String
    var authors: String
    var narrators: String
}

extension QueryResultItem: Hashable {}
