//
//  ApiQueryResultTests.swift
//  Storytel-AssignmentTests
//
//  Created by Mayur Deshmukh on 2022-09-20.
//

import XCTest
@testable import Storytel_Assignment
import SnapshotTesting

final class ApiQueryResultTests: XCTestCase {
    func testDecoding() throws {
        guard let testJsonData = testJsonString.data(using: .utf8) else {
            return XCTFail("Bad Json string")
        }
        let result = try JSONDecoder().decode(ApiQueryResult.self, from: testJsonData)
        XCTAssertEqual(result.items.count, 2)
        assertSnapshot(matching: result, as: .dump)
    }
    
    private let testJsonString = """
    {
      "query": "harry",
      "filter": "books",
      "nextPageToken": "10",
      "totalCount": 5637,
      "items": [
        {
          "id": "134970",
          "deepLink": "storytel://books/109585",
          "title": "Harry Potter och Hemligheternas kammare",
          "bookId": 109585,
          "shareUrl": "https://www.storytel.com/se/sv/books/109585?appRedirect=true",
          "language": "sv",
          "authors": [
            {
              "id": "1998",
              "name": "J.K. Rowling",
              "deepLink": "storytel://booklist/authors/1998/J.K.%20Rowling"
            }
          ],
          "narrators": [
            {
              "id": "167",
              "name": "Björn Kjellman",
              "deepLink": "storytel://booklist/narrators/167/Bj%C3%B6rn%20Kjellman"
            }
          ],
          "formats": [
            {
              "id": "134970",
              "type": "abook",
              "releaseDate": "2017-07-13T00:00:00Z",
              "cover": {
                "url": "https://covers.storytel.com/jpg-640/9781781108963.840360dc-84e7-4a25-af7f-e254cd897ff7",
                "width": 640,
                "height": 640
              },
              "lockedContent": false,
              "released": true,
              "isReleased": true,
              "isLockedContent": false
            },
            {
              "id": "919648",
              "type": "ebook",
              "releaseDate": "2015-12-08T00:00:00Z",
              "cover": {
                "url": "https://covers.storytel.com/jpg-640/9781781105658.456743a3-8761-464e-a978-ab6c7e2a0639",
                "width": 427,
                "height": 640
              },
              "lockedContent": false,
              "released": true,
              "isReleased": true,
              "isLockedContent": false
            }
          ],
          "averageRating": 4.72,
          "seriesInfo": {
            "id": "24647",
            "name": "Harry Potter",
            "orderInSeries": 2,
            "deepLink": "storytel://booklist/series/24647/Harry%20Potter"
          },
          "decoratedTitle": "Harry Potter och Hemligheternas kammare",
          "similarItemsDeepLink": null,
          "similarItemsPageDeepLink": "storytel://inspirational-page/explore/similar-items/134970",
          "kidsBook": true,
          "resultType": "book"
        },
        {
          "id": "134978",
          "deepLink": "storytel://books/109587",
          "title": "Harry Potter och Den Flammande Bägaren",
          "bookId": 109587,
          "shareUrl": "https://www.storytel.com/se/sv/books/109587?appRedirect=true",
          "language": "sv",
          "authors": [
            {
              "id": "1998",
              "name": "J.K. Rowling",
              "deepLink": "storytel://booklist/authors/1998/J.K.%20Rowling"
            }
          ],
          "narrators": [
            {
              "id": "167",
              "name": "Björn Kjellman",
              "deepLink": "storytel://booklist/narrators/167/Bj%C3%B6rn%20Kjellman"
            }
          ],
          "formats": [
            {
              "id": "919671",
              "type": "ebook",
              "releaseDate": "2015-12-08T00:00:00Z",
              "cover": {
                "url": "https://covers.storytel.com/jpg-640/9781781105689.189eb2d6-3362-4ce9-b326-0de4f27ee7e7",
                "width": 427,
                "height": 640
              },
              "lockedContent": false,
              "released": true,
              "isReleased": true,
              "isLockedContent": false
            },
            {
              "id": "134978",
              "type": "abook",
              "releaseDate": "2017-09-07T00:00:00Z",
              "cover": {
                "url": "https://covers.storytel.com/jpg-640/9781781108987.70ac03bb-3a8c-4d49-bd44-5bc5740f3d49",
                "width": 640,
                "height": 640
              },
              "lockedContent": false,
              "released": true,
              "isReleased": true,
              "isLockedContent": false
            }
          ],
          "averageRating": 4.75,
          "seriesInfo": {
            "id": "24647",
            "name": "Harry Potter",
            "orderInSeries": 4,
            "deepLink": "storytel://booklist/series/24647/Harry%20Potter"
          },
          "decoratedTitle": "Harry Potter och Den Flammande Bägaren",
          "similarItemsDeepLink": null,
          "similarItemsPageDeepLink": "storytel://inspirational-page/explore/similar-items/134978",
          "kidsBook": true,
          "resultType": "book"
        }
      ]
    }
"""
}
