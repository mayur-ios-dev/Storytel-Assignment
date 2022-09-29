//
//  StorytelWatchApp.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import SwiftUI

@main
struct StorytelWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            QueryResultsView(
                viewModel: QueryResultViewModel(
                    queryMetadata: .init(
                        query: "Harry",
                        filter: .books,
                        store: "STHP-SE"
                    ),
                    api: ApiQueryService()
                )
            )
        }
    }
}
