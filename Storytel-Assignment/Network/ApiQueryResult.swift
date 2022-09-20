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
