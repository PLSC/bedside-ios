//
//  ContentView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient




struct LoginView: View {
    
    @EnvironmentObject var authUtil : AuthUtil
    
    @State private var username = ""
    @State private var password = ""
    
    init() {
        print("Init app")
        
        
    }
    
    func signIn() {
        authUtil.signIn(userName: username, password: password)
        username = ""
        password = ""
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
                    
            
                  TextField("Username", text: self.$username)
                    .padding()
                    .cornerRadius(20)
                    .keyboardType(.alphabet)
                    .autocapitalization(.none)
                    
                  SecureField("Password", text: self.$password)
                    .padding()
                    .cornerRadius(20)
                    
                    NavigationLink(destination: BaseView(), isActive: $authUtil.isSignedIn) {
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
        LoginView()
    }
}
