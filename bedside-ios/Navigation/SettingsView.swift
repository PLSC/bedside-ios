//
//  SettingsView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient


import Amplify
import AWSS3

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class UserSettingsFormViewModel : ObservableObject {
    @Published var username = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var npi = ""
    @Published var email = ""
    @Published var id = ""
    @Published var isUploadingImage : Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var imageUrl : URL? = nil
    @Published var image : Image? = nil
    
    var allUserValues : User {
        return User(id: id,
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    npi: Int(npi))
    }
    
    
    func setUserValues(user: User?) {
        guard let user = user else { return }
        self.username = user.userName ?? ""
        self.firstName = user.firstName ?? ""
        self.lastName = user.lastName ?? ""
        self.id = user.id
        self.email = user.email
        if let npi = user.npi {
            self.npi = String(describing: npi)
        }
    }
    
    func uploadUserImage() {
        guard let url = imageUrl else {
            print("Select an image to upload")
            return
        }
        
        self.isUploadingImage = true
        
        let progressFn : (Progress) -> () = { progress in print("\(progress.fractionCompleted)") }
        
        let completionFn : (Error?) -> () = { error in
            self.isUploadingImage = false
            if let error = error {
                print(error)
            }
        }
        
        ImageLoadingUtility
            .sharedInstance
            .uploadProfileImage(withUrl: url,
                                userId: id,
                                progressFn:progressFn,
                                completion: completionFn)
    }
    
    func dowloadUserImage() {
        guard !id.isEmpty else { return }
        ImageLoadingUtility.sharedInstance.downloadProfileImage(userId: id) {
            image, error in
            guard let image = image else {
                print("\(error?.localizedDescription ?? "")")
                return
            }
            self.image = Image(uiImage:image)
        }
    }
}

struct SettingsView: View {
    
    @ObservedObject var viewModel = UserSettingsFormViewModel()
    @EnvironmentObject var userLoginState : UserLoginState
    @State var showImagePicker : Bool = false

    let authUtil = AuthUtils()
    
    
    var placeHolderImage : some View {
        return Image(systemName: "person.crop.circle.badge.plus")
            .resizable()
            .foregroundColor(.gray)
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight:75)
            .onTapGesture {
                self.showImagePicker = true
            }
    }
    var profileImage : some View {
        return viewModel.image?.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight:75)
            .clipShape(Circle())
            .shadow(radius: 10)
            .onTapGesture {
                self.showImagePicker = true
            }
    }
    
    func populateUserInfo() {
        self.viewModel.setUserValues(user: self.userLoginState.currentUser)
        self.viewModel.dowloadUserImage()
    }
        
    func signOut() {
        authUtil.signOut()
    }
    
    func submit() {
        UIApplication.shared.endEditing()
        let user = viewModel.allUserValues
        self.userLoginState.updateUser(user: user)
        self.viewModel.uploadUserImage()
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    if viewModel.image != nil {
                        profileImage
                    } else {
                        placeHolderImage
                    }
                    VStack(alignment: .leading) {
                        (Text("Username: ").bold() + Text(viewModel.username)).padding()
                        (Text("Email: ").bold() + Text(viewModel.email)).padding()
                    }
                }
                
                HStack {
                    Text("First Name:").font(.callout).bold()
                    TextField("First Name", text: $viewModel.firstName, onEditingChanged: { didChange in
                        print("editingChanged: \(didChange)")
                    }, onCommit: {
                        print("committed")
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Last Name:").font(.callout).bold()
                    TextField("Last Name", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("NPI: ").font(.callout).bold()
                    TextField("NPI", text:$viewModel.npi)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section {
                    Button(action: {self.submit()}) {
                        Text("Submit Changes")
                    }
                }
                
                Section {
                    Button(action: {self.signOut()}) {
                        Text("Sign Out").foregroundColor(Color.red)
                    }
                }
            }
            .onAppear { self.populateUserInfo() }
            //.modifier(DismissingKeyboard())
            .navigationBarTitle("Settings")
                .sheet(isPresented: $showImagePicker) {
                    PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$viewModel.image, imageUrl: self.$viewModel.imageUrl)
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
