//
//  NewRater.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/11/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine

struct NewRater: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var newRaterViewModel : NewRaterViewModel
    @State var emailErrorString : String?
    @State var isLoading : Bool = false
    @State var presentErrorAlert : Bool = false
    @State var errorAlertText : String = ""
    @State var keyboardHeight : CGFloat = 0
    
    func displayError(error: Error) {
        errorAlertText = error.localizedDescription
    }
    
    func submitRater() {
        self.isLoading = true
        self.newRaterViewModel.submitNewRater(callback: self.submitCompletionCallback(error:))
    }
    
    func submitCompletionCallback(error: Error?) {
        self.isLoading = false
        if let e = error {
            displayError(error: e)
            return
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var emailField : some View {
        VStack(alignment: .leading) {
            TextField("Email Address", text: self.$newRaterViewModel.email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            Text(self.emailErrorString ?? "")
                .onReceive(self.newRaterViewModel.emailError) { errorString in
                    self.emailErrorString = errorString
            }
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading, progress: nil) {
            NavigationView {
                Group {
                    Form {
                        self.emailField
                        
                        TextField("First Name", text: self.$newRaterViewModel.firstName)
                        TextField("Last Name", text: self.$newRaterViewModel.lastName)
                        
                        Section(header: Text("Program")) {
                            
                            Picker("Program", selection: self.$newRaterViewModel.selectedProgram) {
                                ForEach(0..<self.newRaterViewModel.programs.count) { program in
                                    Text(self.newRaterViewModel.programs[program].name)
                                }
                            }
                        }
                        
                        
                        Section {
                            Button(action: {
                                self.submitRater()
                            }) { Text("Submit") }.disabled(!self.newRaterViewModel.isValid)
                        }
                        
                        Section(header: Text("")) {EmptyView() }.padding(.bottom, self.keyboardHeight).onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
                    }
                    .navigationBarTitle("New Rater")
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                       Image(systemName: "xmark")
                    })
                    .alert(isPresented: self.$presentErrorAlert) { () -> Alert in
                        Alert(title: Text("Error"), message: Text("Error submitting new rater"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}

struct NewRater_Previews: PreviewProvider {
    static var previews: some View {
        NewRater(newRaterViewModel: NewRaterViewModel(programs: [], orgId: "test") {_ in })
    }
}
