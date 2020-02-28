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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func apiMutate() {
        let todo = Todo(name: "My New Todo", description: "Get GraphQL working from iOS App")
        _ = Amplify.API.mutate(of: todo, type: .create) { (event) in
            switch event {
            case .completed(let result):
                switch result {
                case .success(let note):
                    print("API Mutate successful, created note: \(note)")
                case .failure(let error):
                    print("Completed with error: \(error.errorDescription)")
                }
            case .failed(let error):
                print("Failed with error \(error.errorDescription)")
            default:
                print("Unexpected event")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.configure()
            print("Amplify initialized")
        } catch {
            print("Failed to configure Amplify \(error)")
        }
        

//        AWSMobileClient.default().signIn(username: "andy", password: "star6969") { (signInResult, error) in
//            if let error = error  {
//                print("\(error.localizedDescription)")
//            } else if let signInResult = signInResult {
//                switch (signInResult.signInState) {
//                case .signedIn:
//                    self.apiMutate()
//                    print("User is signed in: \(String(describing: AWSMobileClient.default().username))")
//                case .smsMFA:
//                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
//                default:
//                    print("Sign In needs info which is not yet supported.")
//                }
//            }
//        }
        
        
        
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

