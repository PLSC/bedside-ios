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
    private let imageLoader = UserProfileImage()
    
    private var cancelSet : Set<AnyCancellable> = []
   
    init() {
        image = imageLoader.profileImage
        
        NotificationCenter.default.publisher(for: ImageEvents.updated)
            .sink { _ in
                self.load()
            }
            .store(in: &cancelSet)
    }
    
    func imageSelected(image: UIImage) {
        imageLoader.profileImage = image
        self.image = image
    }
    
    func load() {
        image = imageLoader.profileImage
    }

    func cancel() {}
}
