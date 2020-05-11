//
//  NewRater.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/11/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct NewRater: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var userSelectedCallback : (User) -> () = {_ in}
    
    @State var firstName: String = ""
    @State var lastName : String = ""
    @State var email : String = ""
    @State var selectedProgram : Int = 0
    
    var programs : [Program]
    
    func createMembership(user: User, programId: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        
        let createMembershipInput = CreateMembershipInput(role: .user, userId: user.id, programId: programId)
        let createMembershipMutation = CreateMembershipMutation(input: createMembershipInput)
        
        appSyncClient?.perform(mutation: createMembershipMutation, resultHandler: { (result, err) in
            print("Success")
            self.userSelectedCallback(user)
            self.presentationMode.wrappedValue.dismiss()
        })
    }
    
    func submitNewRater() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let createUserInput = CreateUserInput(email: email, firstName: firstName, lastName: lastName, isRater: true)
        let createUserMutation = CreateUserMutation(input: createUserInput)
        appSyncClient?.perform(mutation: createUserMutation, resultHandler: { (data, error) in
            guard let result = data?.data?.createUser else {
                print("error creating rater")
                return
            }
            
            print("rater created")
            let rater = User(id: result.id, email: result.email, firstName: result.firstName, lastName: result.lastName)
            self.createMembership(user: rater, programId: self.programs[self.selectedProgram].id)
        })
    }
    
    var body: some View {
        NavigationView {
            Group {
                Form {
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    
                    Section(header: Text("Program")) {
                        
                        Picker("", selection: $selectedProgram) {
                            ForEach(programs, id: \.id) { program in
                                Text(program.name)
                            }
                        }.pickerStyle(WheelPickerStyle())
                    }
                    
                    
                    Section {
                        Button(action: {
                            self.submitNewRater()
                        }) { Text("Submit") }
                    }
                    
                    //TODO: Search users and find existing.
//                    Section(header: Text("Existing Users")) {
//                        Text("Test")
//                        Text("Test")
//                        Text("Test")
//                    }
                }
                .navigationBarTitle("New Rater")
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                   Image(systemName: "xmark")
                })
            }
            
        }
    }
}

struct NewRater_Previews: PreviewProvider {
    static var previews: some View {
        NewRater(programs: [])
    }
}
