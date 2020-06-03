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
    @ObservedObject var viewModel : NewRaterViewModel
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
        self.viewModel.submitNewRater(callback: self.submitCompletionCallback(error:))
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
            TextField("Email Address", text: self.$viewModel.email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            Text(self.viewModel.emailErrorMessage ?? "")
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            NavigationView {
                Group {
                    Form {
                        self.emailField
                        
                        TextField("First Name", text: self.$viewModel.firstName)
                        TextField("Last Name", text: self.$viewModel.lastName)
                        
                        Section(header: Text("Program")) {
                            
                            Picker("Program", selection: self.$viewModel.selectedProgram) {
                                ForEach(0..<self.viewModel.programs.count) { program in
                                    Text(self.viewModel.programs[program].name)
                                }
                            }
                        }
                        
                        
                        Section {
                            Button(action: {
                                self.submitRater()
                            }) { Text("Submit") }.disabled(!self.viewModel.isRaterValid)
                        }
                        
                        Section(header: Text("")) {EmptyView() }.padding(.bottom, self.keyboardHeight).onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
                    }
                    .navigationBarTitle("New Rater")
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                       Image(systemName: "xmark")
                        .imageScale(.large)
                        .padding(.leading, 20)
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
        NewRater(viewModel: NewRaterViewModel(programs: [], orgId: "test") {_ in })
    }
}
