//
//  ApiImageLoaderService.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-22.
//

import UIKit
import Combine

protocol ApiImageLoaderServiceType {
    func image(withUrlString: String?) -> AnyPublisher<UIImage, Error>
}

final class ApiImageLoaderService {
    private let session: URLSessionType
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

extension ApiImageLoaderService: ApiImageLoaderServiceType {
    func image(withUrlString urlString: String?) -> AnyPublisher<UIImage, Error> {
        guard let urlString = urlString else {
            return .throwing(ApiImageLoaderServiceError.nilImageUrl)
        }
        guard let url = URL(string: urlString) else {
            return .throwing(
                URLError(
                    .badURL,
                    userInfo: [
                        "failedImageUrl": urlString
                    ]
                )
            )
        }
        if let cachedImage = cachedImage(for: url) {
            return Just(cachedImage)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        let urlrequest = URLRequest(
            url: url,
            timeoutInterval: 120
        )
        
        return session
            .dataTaskPublisher(for: urlrequest)
            .tryMap { [weak self] data, _ in
                guard let image = UIImage(data: data) else {
                    throw ApiImageLoaderServiceError.couldNotBuildImageFromData(data)
                }
                self?.cache(image, for: url)
                return image
            }.eraseToAnyPublisher()
    }
    
    private func cache(_ image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url as AnyObject)
    }
    
    private func cachedImage(for url: URL) -> UIImage? {
        imageCache.object(forKey: url as AnyObject)
    }
}

enum ApiImageLoaderServiceError: Error {
    case nilImageUrl
    case couldNotBuildImageFromData(Data)
}

extension AnyPublisher where Output == UIImage, Failure == Error {
    static func throwing(_ error: Error) -> Self {
        Just(UIImage())
            .tryMap { _ in
                throw error
            }
            .eraseToAnyPublisher()
    }
}
