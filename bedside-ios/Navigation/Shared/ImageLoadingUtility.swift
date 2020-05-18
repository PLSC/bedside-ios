//
//  ImageUploadUtility.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/18/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSS3

struct AWSConfigOptions {
    let serviceKey = "transfer-utility-with-advanced-options"
    let region = AWSRegionType.USEast1
    
    var poolId : String? {
        let root = AWSInfo.default().rootInfoDictionary
        guard let credentialsProvider = root["CredentialsProvider"] as? [String: Any],
            let cognitoIdentity = credentialsProvider["CognitoIdentity"] as? [String: Any] ,
            let def = cognitoIdentity["Default"] as? [String: Any],
            let poolId = def["PoolId"] as? String else { return nil }
        return poolId
    }
    
    var bucket : String? {
        guard let tuConfig = AWSInfo.default().rootInfoDictionary["S3TransferUtility"] as? Dictionary<String, Any>,
            let def = tuConfig["Default"] as? Dictionary<String, Any>,
            let bucket = def["Bucket"] as? String  else { return nil }
        return bucket
    }
}

class ImageLoadingUtility {
    
    let configOptions : AWSConfigOptions
    let publicKey = "public"
    let imageName = "profile.jpg"
    let contentType = "image/jpeg"
    
    func imageFileName(forUserId id: String) -> String {
        return "\(publicKey)/\(id)/\(imageName)"
    }
    
    var registrationCompletionHandler : (Error?) -> () = { error in
        if let error = error {
             //Handle registration error.
            print("register error \(error.localizedDescription)")
         }
        ///TODO: notify of
        print("Image utility registered")
    }
    
    var transferUtility: AWSS3TransferUtility?  {
        AWSS3TransferUtility.s3TransferUtility(forKey: configOptions.serviceKey)
    }
        
    static let sharedInstance: ImageLoadingUtility = {
        let instance = ImageLoadingUtility(awsConfigOptions: AWSConfigOptions())
        instance.config()
        return instance
    }()
    
    init(awsConfigOptions: AWSConfigOptions) {
        self.configOptions = awsConfigOptions
    }
    
    func downloadProfileImage(userId: String,
                              completion: @escaping (UIImage?, Error?) -> () = {_,_ in }) {
        guard let bucket = configOptions.bucket else {
                   print("AWS Config Failed")
                   return
               }
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
           // Do something e.g. Update a progress bar.
                print("progress:\(progress)")
           })
        }

        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
           DispatchQueue.main.async(execute: {
           // Do something e.g. Alert a user for transfer completion.
           // On failed downloads, `error` contains the error object.
                print("download complete")
                if let data = data {
                    let uiImage = UIImage(data: data)
                    completion(uiImage, error)
                } else {
                    completion(nil, error)
                }
           })
        }

        transferUtility!.downloadData(
              fromBucket: bucket,
              key: imageFileName(forUserId: userId),
              expression: expression,
              completionHandler: completionHandler
              ).continueWith {
                    (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                     }

                     if let _ = task.result {
                       // Do something with downloadTask.

                     }
                     return nil;
             }
    }
    
    func uploadProfileImage(withUrl url: URL,
                            userId: String,
                            progressFn: @escaping (Progress) -> (),
                            completion: @escaping (Error?) -> ()) {
        guard let bucket = configOptions.bucket else {
            print("AWS Config Failed")
            return
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
              DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                  progressFn(progress)
             })
        }

        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
           DispatchQueue.main.async(execute: {
              print("completed: \(error?.localizedDescription ?? "Successful" )")
              completion(error)
           })
        }
        do {
            let data = try Data(contentsOf: url)
            transferUtility!.uploadData(data,
                      bucket: bucket,
                      key: imageFileName(forUserId: userId),
                      contentType: contentType,
                      expression: expression,
                      completionHandler: completionHandler).continueWith {
                         (task) -> AnyObject? in
                             if let error = task.error {
                                print("Error: \(error.localizedDescription)")
                             }

                             if let _ = task.result {
                                // Do something with uploadTask.
                             }
                             return nil;
                     }
        } catch(let error) {
            print("Failure reading image data at url: \(url), error \(error)")
        }
    }
    
    func config() {
        guard let poolId = configOptions.poolId else {
            print("cannot read awsconfig")
            return
        }
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: configOptions.region,
                                                        identityPoolId: poolId)
        let configuration = AWSServiceConfiguration(region: configOptions.region,
                                                    credentialsProvider: credentialProvider)

        //Setup the transfer utility configuration
        let tuConf = AWSS3TransferUtilityConfiguration()

        //Register a transfer utility object asynchronously
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: configOptions.serviceKey,
            completionHandler: registrationCompletionHandler
        )
    }
}
