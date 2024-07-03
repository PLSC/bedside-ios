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
    
    @State var isLoading : Bool = false
    @State var presentErrorAlert : Bool = false
    @State var errorAlertText : String = ""
    @State var keyboardHeight : CGFloat = 0
    
    func displayError(error: Error) {
        errorAlertText = error.localizedDescription
        presentErrorAlert = true
    }
    
    func submitRater() async {
        self.isLoading = true

        let error = await self.viewModel.submitNewRater()
        self.submitCompletionCallback(error: error)
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
        let emailBinding = Binding<String>(get: {self.viewModel.email}, set: {self.viewModel.email = $0.lowercased()})
        let showUserSuggestion = self.viewModel.recommendedUser != nil
        
        return HStack {
            VStack(alignment: .leading) {
                TextField("Email Address", text: emailBinding)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                Text(self.viewModel.emailErrorMessage ?? "")
            }
            if showUserSuggestion {
                Image(systemName: "arrowshape.turn.up.right.circle")
                    .font(.system(size: 40))
                    .foregroundColor(Color.lightTeal)
                    .onTapGesture {
                        self.viewModel.selectReccomendedUser()
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    var body: some View {
        
        return LoadingView(isShowing: $isLoading) {
            NavigationView {
                Group {
                    Form {
                        self.emailField
                        
                        TextField("First Name", text: self.$viewModel.firstName)
                            .autocapitalization(.words)
                        TextField("Last Name", text: self.$viewModel.lastName)
                            .autocapitalization(.words)
                        
                        Section {
                            Button(action: {
                                Task {
                                    await self.submitRater()
                                }
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
                        Alert(title: Text("Error"), message: Text("Error submitting new rater: \(self.errorAlertText)"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}
