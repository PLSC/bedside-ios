//
//  ContentView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient


struct ContentView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var signedInMessage = ""
    @State private var isLoggedIn: Bool = false
    
    init() {
        print("Init app")
    }
    
    func signIn() {
        
        AWSMobileClient.default().signIn(username: email, password: password) { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    if let user = AWSMobileClient.default().username {
                        let loggedInMessage = "User is signed in: \(user)"
                        self.signedInMessage = loggedInMessage
                        self.isLoggedIn = true
                        print(loggedInMessage)
                    }
                   
                   
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer().padding([.top, .bottom], 50)
                VStack(alignment: .center, spacing: 15) {
                  Text("Bedside Procedures")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding([.top, .bottom], 20)
                    
            
                  TextField("Email", text: self.$email)
                    .padding()
                    .cornerRadius(20)
                    .keyboardType(/*@START_MENU_TOKEN@*/.emailAddress/*@END_MENU_TOKEN@*/)
                    
                  SecureField("Password", text: self.$password)
                    .padding()
                    .cornerRadius(20)
                    
                    NavigationLink(destination: BaseView(rootIsActive: self.$isLoggedIn), isActive: self.$isLoggedIn) {
                        Text("")
                    }

                    Button(action:{self.signIn()}) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    
                    }
                    
                }.padding()
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
