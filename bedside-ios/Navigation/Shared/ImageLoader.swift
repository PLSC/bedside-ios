//
//  ImageLoader.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/18/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

enum ImageLoaderError : Error {
    case imageDecode
}

class ImageLoader {
    typealias Handler = (Result<UIImage, Error>) -> Void
    
    private let cache = Cache<User.ID, Data>()
    
    static let sharedInstance : ImageLoader = {
        return ImageLoader()
    }()
    
    func loadUserImage(withID id: User.ID, then handler: @escaping Handler) {
        if let cached = cache[id], let image = UIImage(data: cached) {
            print("cache hit with id: \(id)")
            return handler(.success(image))
        }
        
        print("cache miss with id: \(id)")
        S3ImageLoadingUtility.sharedInstance.config { (error) in
            if let error = error {
                print("error configuring S3ImageLoadingUtility \(error)")
                return
            }
            
            S3ImageLoadingUtility.sharedInstance.downloadProfileImageData(userId: id) {
                [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        handler(.failure(ImageLoaderError.imageDecode))
                        return
                    }
                    self?.cache[id] = data
                    handler(.success(image))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
        
    }
}
