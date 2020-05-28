//
//  SettingsView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient
import Combine


import Amplify
import AWSS3

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//TODO: Clean up image downloading stuff from this.
class UserSettingsFormViewModel : ObservableObject {
    var currentUser : User?
    @Published var username = ""

    @Published var formIsDirty = false
    @Published var firstName = "" {
        didSet {
            if let currentFirstName = currentUser?.firstName, currentFirstName != firstName {
                formIsDirty = true
            }
        }
    }
    @Published var lastName = "" {
        didSet {
            if let currentLastName = currentUser?.lastName, currentLastName != lastName {
                formIsDirty = true
            }
        }
    }
    @Published var npi = "" {
        didSet {
            if npi.count > 10 && oldValue.count <= 10 {
                npi = oldValue
            }
            if let currentNpi = currentUser?.npi, currentNpi != Int(npi) {
                formIsDirty = true
            }
        }
    }
    @Published var email = ""
    @Published var id = ""
    @Published var isUploadingImage : Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var imageUrl : URL? = nil
    @Published var image : Image? = nil
    @Published var formIsValid = false
    
    var cancellableSet : Set<AnyCancellable> = []
    
    func npiIsValid(npi: String) -> Bool {
        guard Int(npi) != nil else { return false }
        return npi.count < 11
    }
    
    init() {
        Publishers.CombineLatest3($firstName, $lastName, $npi).receive(on: RunLoop.main).map {
                firstName, lastName, npi in
                return (firstName.count >= 2) &&
                    (lastName.count >= 2) &&
                    self.npiIsValid(npi: npi)
            }.assign(to: \.formIsValid, on: self)
            .store(in: &cancellableSet)
    }
    
    var allUserValues : User {
        return User(id: id,
                    userName: username,
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    npi: Int(npi))
    }
    
    
    func setUserValues(user: User?) {
        currentUser = user
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
}

struct SettingsView: View {
    
    @ObservedObject var viewModel = UserSettingsFormViewModel()
    @ObservedObject var userImageLoader = UserImageLoader()
    @EnvironmentObject var userLoginState : UserLoginState
    @State var image: UIImage?
    @State var showImagePicker : Bool = false
    @State var isLoading: Bool = false
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    let authUtil = AuthUtils()
    
    
    var placeHolderImage : some View {
        return Image(systemName: "person.crop.circle.badge.plus")
            .resizable()
            .foregroundColor(.gray)
            .aspectRatio(contentMode: .fill)
            .frame(maxHeight:75)
            .onTapGesture {
                self.showImagePicker = true
            }
    }
    var profileImage : some View {
        return UserImage()
            .frame(width: 50, height: 50)
            .aspectRatio(contentMode: .fill)
            .onTapGesture {
                self.showImagePicker = true
            }
    }
    
    func populateUserInfo() {
        self.viewModel.setUserValues(user: self.userLoginState.currentUser)
        if let image = self.userImageLoader.image {
            self.image = image
        }
    }
        
    func signOut() {
        authUtil.signOut()
    }
    
    func submit() {
        UIApplication.shared.endEditing()
        let user = viewModel.allUserValues
        isLoading = true
        self.userLoginState.updateUser(user: user) {
            result in
            self.isLoading = false
            switch result {
            case .success(user?):
                print("User successfully updated \(user)")
                self.viewModel.setUserValues(user: user)
                self.viewModel.formIsDirty = false
            case .success(let user):
                print("Success, but no mapped data \(String(describing: user))")
            case .failure(let error):
                self.showAlert = true
                self.errorMessage = "An error occurred while updating user information."
                print(error)
            }
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            NavigationView {
                Form {
                    HStack {
                        
                        self.profileImage
                        
                        VStack(alignment: .leading) {
                            (Text("Username: ").bold() + Text(self.viewModel.username)).lineLimit(3)
                            (Text("Email: ").bold() + Text(self.viewModel.email)).lineLimit(3)
                        }
                    }
                    .padding()
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    
                    HStack {
                        Text("First Name:").font(.callout).bold()
                        TextField("First Name", text: self.$viewModel.firstName, onEditingChanged: { didChange in
                            print("editingChanged: \(didChange)")
                        }, onCommit: {
                            print("committed")
                        }).textFieldStyle(RoundedBorderTextFieldStyle())
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    
                    HStack {
                        Text("Last Name:").font(.callout).bold()
                        TextField("Last Name", text: self.$viewModel.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    
                    HStack {
                        Text("NPI: ").font(.callout).bold()
                        TextField("NPI", text:self.$viewModel.npi)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    
                    Section {
                        Button(action: {self.submit()}) {
                            Text("Submit Changes")
                        }.disabled(!self.viewModel.formIsValid && self.viewModel.formIsDirty)
                        .foregroundColor(self.viewModel.formIsValid && self.viewModel.formIsDirty ? Color.blue : Color.gray)
                    }
                    
                    Section {
                        Button(action: {self.signOut()}) {
                            Text("Sign Out").foregroundColor(Color.red)
                        }
                    }
                    
                    Section {
                        Text("App Version: \(self.appVersionString) (\(self.buildNumber))").font(.caption).foregroundColor(.gray)
                        Text("Icon made by Freepik from www.flaticon.com.").font(.caption).foregroundColor(.gray)
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                }
                .navigationBarTitle("Settings")
                .sheet(isPresented: self.$showImagePicker) {
                    PhotoCaptureView(image: self.$image, showImagePicker: self.$showImagePicker)
                }
                .onAppear {
                    self.populateUserInfo()
                }
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("Error"),
                          message: Text(self.errorMessage),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
