//
//  QueryResultItem.swift
//  StorytelWatch Watch App
//
//  Created by Mayur Deshmukh on 2022-09-24.
//

import SwiftUI

extension QueryResultItem: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                image
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .lineLimit(3)
                    Text(authors)
                        .font(.caption2)
                    Text(narrators)
                        .font(.caption2)
                }
                Spacer()
            }
            Divider()
        }
    }
}

private extension QueryResultItem {
    var image: some View {
        AsyncImage(
            url: URL(string: imageUrl),
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        maxWidth: .thumbnailSize
                    )
            },
            placeholder: {
                ProgressView()
                    .frame(
                        maxWidth: .thumbnailSize,
                        maxHeight: .thumbnailSize
                    )
            }
        )
    }
}

private extension CGFloat {
    static let thumbnailSize: CGFloat = 40
}

struct QueryResultItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QueryResultItem(
                imageUrl: "https://covers.storytel.com/jpg-640/9781781108963.840360dc-84e7-4a25-af7f-e254cd897ff7",
                title: "Harry Potter och Hemligheternas kammare",
                authors: "J.K Rowling",
                narrators: "Mayur Deshmukh"
            )
            .previewLayout(.sizeThatFits)
            QueryResultItem(
                imageUrl: "https://covers.storytel.com/jpg-640/9781781108963.840360dc-84e7-4a25-af7f-e254cd897ff7",
                title: "Harry Potter och Hemligheternas kammare",
                authors: "J.K Rowling",
                narrators: "Mayur Deshmukh"
            )
            .previewLayout(.sizeThatFits)
        }
    }
}
