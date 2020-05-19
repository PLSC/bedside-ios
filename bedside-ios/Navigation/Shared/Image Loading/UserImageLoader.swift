//
//  ImageLoader.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/19/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Combine

class UserImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let id: User.ID
   

    init(userId: User.ID) {
        self.id = userId
    }
    
    func load() {
        guard !id.isEmpty else { return }
        CachingImageLoader.sharedInstance.loadUserImage(withID: id) { result in
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                print("error loading image \(error)")
            }
        }
    }

    func cancel() {}
}
