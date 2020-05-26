//
//  UserProfileImage.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/20/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

class UserProfileImage {
    let imageName = "profile.png"
    let userDefaultsKey = "userProfileImage"
    private var cachedImage : UIImage?
    
    var imageUrl : URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(imageName)
    }
    
    var storedProfileImage : Bool {
        get {
            UserDefaults.standard.bool(forKey: "storedProfileImage")
        }
        set(needs) {
            UserDefaults.standard.set(needs, forKey: "storedProfileImage")
        }
    }
    
    var profileImage : UIImage? {
        get {
            if let i = cachedImage {
                return i
            } else {
                do {
                    let data = try Data(contentsOf: imageUrl)
                    cachedImage = UIImage(data: data)
                    return cachedImage
                } catch(let error) {
                    print("error loading imagee \(error)")
                }
                
                return nil
            }
        }
        set(image) {
            cachedImage = nil

            guard let data = image?.jpegData(compressionQuality: 0.75) else {
                print("cannot write image data")
                return
            }

            do {
                try data.write(to: imageUrl)
                storedProfileImage = true
            } catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }
}
