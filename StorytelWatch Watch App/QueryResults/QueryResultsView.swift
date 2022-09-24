//
//  ContentView.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import SwiftUI

struct QueryResultsView<VM: QueryResultViewModelType>: View {
    @ObservedObject var viewModel: VM
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.self) { $0 }
                if viewModel.hasItemsToLoad {
                    HStack{
                        ProgressView()
                        .onAppear {
                            viewModel.loadData()
                        }
                    }
                }
            }
        }
    }
}

struct QueryResultsView_Previews: PreviewProvider {
    static var previews: some View {
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
