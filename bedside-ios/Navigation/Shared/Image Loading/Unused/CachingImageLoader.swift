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
    private let cache = Cache<String, Data>()

    static let sharedInstance : CachingImageLoader = {
        return CachingImageLoader()
    }()

    func uploadUserImage(imageUrl: URL,
                         userId: String, progressHandler: @escaping (Progress) -> ()) async -> Result<Bool, Error> {
        do {
            let data = try Data(contentsOf: imageUrl)
            cache[userId] = data
        } catch (let error) {
            print("could not read image data from url: \(error)")
        }

        let error = await S3ImageLoadingUtility.sharedInstance.uploadProfileImage(withUrl: imageUrl, userId: userId, progressFn: progressHandler)

        if let error = error {
            return .failure(error)
        } else {
            return .success(true)
        }
    }

    func loadUserImage(withID id: String) async ->Result<UIImage, Error> {
        if let cached = cache[id], let image = UIImage(data: cached) {
            print("cache hit with id: \(id)")
            return .success(image)
        }

        print("cache miss with id: \(id)")

        let result = await S3ImageLoadingUtility.sharedInstance.downloadProfileImageData(userId: id)

        switch result {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                return .failure(ImageLoaderError.imageDecode)
            }

            self.cache[id] = data

            return .success(image)
        case .failure(let error):
            return .failure(error)
        }
    }
}
