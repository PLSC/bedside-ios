//
//  ImageLoader.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/19/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

class UserImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }
    
    func load() {}

    func cancel() {}
}
