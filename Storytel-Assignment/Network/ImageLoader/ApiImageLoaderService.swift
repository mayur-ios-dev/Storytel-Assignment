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

