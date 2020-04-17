//
//  AppDelegate.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import UIKit
import AWSMobileClient
import AmplifyPlugins
import Amplify
import AWSAppSync

extension AWSMobileClient: AWSCognitoUserPoolsAuthProviderAsync {
    public func getLatestAuthToken(_ callback: @escaping (String?, Error?) -> Void) {
        getTokens { (tokens, error) in
            if error != nil {
                callback(nil, error)
            } else {
                callback(tokens?.idToken?.tokenString, nil)
            }
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appSyncClient: AWSAppSyncClient?
    
    func initAmplify() {
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        let storagePlugin = AWSS3StoragePlugin()
        
        do {
              try Amplify.add(plugin: apiPlugin)
              try Amplify.add(plugin: storagePlugin)
              try Amplify.configure()
              print("Amplify initialized")
          } catch {
              print("Failed to configure Amplify \(error)")
          }
    }
    
    func initAppSync() {
        do {
                   let cacheConfiguration = try AWSAppSyncCacheConfiguration()
                   let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: AWSAppSyncServiceConfig(), userPoolsAuthProvider: AWSMobileClient.default(), cacheConfiguration: cacheConfiguration)
                   appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
                   print("Appsync configured")
               } catch(let error) {
                   print("AppSync is a no-go: \(error)")
               }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
      
        
        AWSMobileClient.default().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            
            self.initAmplify()
            self.initAppSync()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

