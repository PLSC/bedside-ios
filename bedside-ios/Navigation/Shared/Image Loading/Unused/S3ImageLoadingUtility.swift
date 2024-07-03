//
//  ImageUploadUtility.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/18/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Amplify
import SwiftUI


enum S3ImageLoadingUtilityError : Error {
    case imageDecodingError
}
class S3ImageLoadingUtility {

    static let sharedInstance: S3ImageLoadingUtility = {
        let instance = S3ImageLoadingUtility()
        return instance
    }()


    func downloadProfileImageData(userId: String) async -> Result<Data,Error> {
        print("downloading with userID: \(userId)")

        let downloadTask = Amplify.Storage.downloadData(path: .fromString("simpl-prd-images/\(userId).png"))

        Task {
            for await progress in await downloadTask.progress {
                print("Progress: \(progress)")
            }
        }

        do {
            let success = try await downloadTask.value

            return .success(success.base64EncodedData())
        } catch {
            return .failure(error)
        }
    }


    func uploadProfileImage(withUrl url: URL, userId: String, progressFn: @escaping (Progress) -> ()) async -> Error? {
        do {
            let data = try Data(contentsOf: url)

            let uploadTask = Amplify.Storage.uploadData(
                path: .fromString("simpl-prd-images/\(userId).png"),
                data: data
            )

            Task {
                for await progress in await uploadTask.progress {
                    DispatchQueue.main.async(execute: {
                        // Do something e.g. Update a progress bar.
                        progressFn(progress)
                    })
                }
            }

            let value = try await uploadTask.value
            print("Completed: \(value)")

            return nil
        } catch(let error) {
            print("error uploading image \(error)")
            return error
        }
    }

    
}
