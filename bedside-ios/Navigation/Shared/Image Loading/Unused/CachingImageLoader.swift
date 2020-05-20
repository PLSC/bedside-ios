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

class CachingImageLoader {
    typealias Handler = (Result<UIImage, Error>) -> Void
    
    private let cache = Cache<User.ID, Data>()
    
    static let sharedInstance : CachingImageLoader = {
        return CachingImageLoader()
    }()
    
    func uploadUserImage(imageUrl: URL,
                         userId: User.ID, progressHandler: @escaping (Progress) -> (),
                         completionHandler: @escaping (Result<Bool, Error>)->()) {
        do {
            let data = try Data(contentsOf: imageUrl)
            cache[userId] = data
        } catch (let error) {
            print("could not read image data from url: \(error)")
        }
        
        S3ImageLoadingUtility.sharedInstance.configUploads { error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                S3ImageLoadingUtility.sharedInstance.uploadProfileImage(withUrl: imageUrl, userId: userId, progressFn: progressHandler) { error in
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.success(true))
                    }
                }
            }
        }
    }
    
    func loadUserImage(withID id: User.ID, then handler: @escaping Handler) {
        if let cached = cache[id], let image = UIImage(data: cached) {
            print("cache hit with id: \(id)")
            return handler(.success(image))
        }
        
        print("cache miss with id: \(id)")
       
            
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
