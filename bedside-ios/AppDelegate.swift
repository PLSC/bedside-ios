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
import AWSS3

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
    
    var appSyncPrivateClient: AWSAppSyncClient?
    var appSyncPublicClient: AWSAppSyncClient?
    
    func initAmplify() {
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        
        do {
              try Amplify.add(plugin: apiPlugin)
              try Amplify.add(plugin: AWSS3StoragePlugin())
              try Amplify.configure()
              print("Amplify initialized")
          } catch {
              print("Failed to configure Amplify \(error)")
          }
    }
    
    func initAppSync() {
        do {
            // Public appsync client setup
            let servicePublicConfig = try AWSAppSyncServiceConfig(forKey: "bedside_API_KEY")
            let cachePublic = try AWSAppSyncCacheConfiguration(useClientDatabasePrefix: true, appSyncServiceConfig: servicePublicConfig)
            let appSyncPublicConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: servicePublicConfig,
                                                                 cacheConfiguration: cachePublic)
            appSyncPublicClient = try AWSAppSyncClient(appSyncConfig: appSyncPublicConfig)

            // Private appsync client setup
            let servicePrivateConfig = try AWSAppSyncServiceConfig()
            let cachePrivate = try AWSAppSyncCacheConfiguration(useClientDatabasePrefix: true, appSyncServiceConfig: servicePrivateConfig)
            let appSyncPrivateConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: servicePrivateConfig, userPoolsAuthProvider: AWSMobileClient.default(), cacheConfiguration: cachePrivate)
            appSyncPrivateClient = try AWSAppSyncClient(appSyncConfig: appSyncPrivateConfig)
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
            
            
        }
        
        self.initAmplify()
        self.initAppSync()
        self.initStyles()
        
        return true
    }
    
    func initStyles() {
//       UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
//       UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 30)!]
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

