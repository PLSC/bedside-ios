//
//  ImageUploadUtility.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/18/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSS3
import Amplify

struct AWSConfigOptions {
    let serviceKey : String = "transfer-utility-with-advanced-options"
    let uploadServiceKey : String = "s3-upload-transfer-utility"
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

enum S3ImageLoadingUtilityError : Error {
    case imageDecodingError
}
class S3ImageLoadingUtility {
    
    let configOptions : AWSConfigOptions
    let publicKey = "public"
    let imageName = "profile.jpg"
    let contentType = "image/jpeg"
    var registrationComplete = false
    
    //TODO: Make this a user extension.
    func imageFileName(forUserId id: String) -> String {
        return "\(publicKey)/\(id)/\(imageName)"
    }
    
    func userImageKey(forUserId id: String) -> String {
        return "\(id)/\(imageName)"
    }
    
    var downloadUtility: AWSS3TransferUtility?  {
        AWSS3TransferUtility.s3TransferUtility(forKey: configOptions.serviceKey)
    }
    
    var uploadUtility: AWSS3TransferUtility? {
        AWSS3TransferUtility.s3TransferUtility(forKey: configOptions.uploadServiceKey)
    }
        
    static let sharedInstance: S3ImageLoadingUtility = {
        let instance = S3ImageLoadingUtility(awsConfigOptions: AWSConfigOptions())
        return instance
    }()
    
    init(awsConfigOptions: AWSConfigOptions) {
        self.configOptions = awsConfigOptions
    }
    
    typealias DataCompletion = (Result<Data,Error>) -> ()
    
    func downloadProfileImageData(userId: User.ID, completion: @escaping DataCompletion ) {
        print("downloading with userID: \(userId)")
        let _ = Amplify.Storage.downloadData(key: userImageKey(forUserId: userId)) { (event) in
            switch event {
            case .completed(let data):
                completion(.success(data))
            case .failed(let error):
                completion(.failure(error))
            default:
                print("")
            }
        }
    }
    
    func downloadProfileImage(userId: User.ID,
                              completion: @escaping (Result<UIImage, Error>) -> () = { _ in }) {
        downloadProfileImageData(userId: userId) { result in
            switch result {
            case .success(let data):
                guard let uiImage = UIImage(data: data) else {
                    completion(.failure(S3ImageLoadingUtilityError.imageDecodingError))
                    break
                }
                completion(.success(uiImage))
            case .failure(let error):
                completion(.failure(error))
            }
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

        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock? = { (task, error) -> Void in
           DispatchQueue.main.async(execute: {
              print("completed: \(error?.localizedDescription ?? "Successful" )")
              completion(error)
           })
        }
        
        do {
            let data = try Data(contentsOf: url)
            uploadUtility?.uploadData(data,
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
            print("error uploading image \(error)")
        }
    }
    
    
    
    func config(registrationCompletion: @escaping (Error?)->()) {
        if self.registrationComplete {
            registrationCompletion(nil)
        }
        
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
        let middleware : (Error?) -> () = { error in
            self.registrationComplete = error == nil
            registrationCompletion(error)
        }

        //Register a transfer utility object asynchronously
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: configOptions.serviceKey,
            completionHandler: middleware
        )
    }
    
    var uploadRegistrationComplete = false
    
    func configUploads(registrationCompletion: @escaping (Error?)->()) {
        if self.uploadRegistrationComplete {
            registrationCompletion(nil)
        }
        
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
        let middleware : (Error?) -> () = { error in
            self.uploadRegistrationComplete = error == nil
            registrationCompletion(error)
        }

        //Register a transfer utility object asynchronously
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: configOptions.uploadServiceKey,
            completionHandler: middleware
        )
    }
}
