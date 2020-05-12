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
    @ObservedObject var newRaterViewModel : NewRaterViewModel
    @State var emailErrorString : String?
    
    func displayError(error: Error) {
        //TODO: Map errors to ui.
    }
    
    func submitCompletionCallback(error: Error?) {
        guard error != nil else {
            displayError(error: error!)
            return
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            Group {
                Form {
                    VStack(alignment: .leading) {
                        TextField("Email Address", text: $newRaterViewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        Text(self.emailErrorString ?? "")
                            .onReceive(newRaterViewModel.emailError) { errorString in
                                self.emailErrorString = errorString
                        }
                    }
                    
                    TextField("First Name", text: $newRaterViewModel.firstName)
                    TextField("Last Name", text: $newRaterViewModel.lastName)
                    
                    Section(header: Text("Program")) {
                        
                        Picker("Program", selection: $newRaterViewModel.selectedProgram) {
                            ForEach(0..<newRaterViewModel.programs.count) { program in
                                Text(self.newRaterViewModel.programs[program].name)
                            }
                        }
                    }
                    
                    
                    Section {
                        Button(action: {
                            self.newRaterViewModel.submitNewRater(callback: self.submitCompletionCallback(error:))
                        }) { Text("Submit") }.disabled(!self.newRaterViewModel.isValid)
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
        NewRater(newRaterViewModel: NewRaterViewModel(programs: []) {_ in })
    }
}
