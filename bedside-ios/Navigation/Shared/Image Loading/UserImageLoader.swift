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
   
    init() {
        image = imageLoader.profileImage
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
