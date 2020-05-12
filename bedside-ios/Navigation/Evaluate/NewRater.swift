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
    
    var body: some View {
        NavigationView {
            Group {
                Form {
                    TextField("Email Address", text: $newRaterViewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
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
                            self.newRaterViewModel.submitNewRater(callback: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
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
        NewRater(newRaterViewModel: NewRaterViewModel(programs: []) {_ in })
    }
}
