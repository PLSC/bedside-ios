//
//  SettingsView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Amplify
import Combine

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
    @Published var firstName = ""
    @Published var lastName = ""
    
    @Published var email = ""
    @Published var id = ""
    @Published var isUploadingImage : Bool = false
    @Published var uploadProgress: Float = 0.0
    @Published var imageUrl : URL? = nil
    @Published var image : Image? = nil
    @Published var formIsValid = false
    @Published var enableSubmit = false
    
    var cancellableSet : Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest($firstName, $lastName).receive(on: RunLoop.main).map {
                firstName, lastName in
                return (firstName.count >= 1) && (lastName.count >= 1)
            }
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest($firstName, $lastName)
            .receive(on: RunLoop.main)
            .map { firstName, lastName in                guard let currentFirstName = self.currentUser?.firstName,
                    let currentLastName = self.currentUser?.lastName else { return false }
                return currentLastName != lastName || currentFirstName != firstName
            }
            .assign(to: \.formIsDirty, on: self)
            .store(in: &cancellableSet)
            
        
        Publishers.CombineLatest($formIsValid, $formIsDirty)
            .receive(on: RunLoop.main)
            .map { valid, dirty in
                return valid && dirty
            }
            .assign(to: \.enableSubmit, on: self)
            .store(in: &cancellableSet)
    }
    
    var allUserValues : User {
        return User(id: id,
                    orgID: currentUser?.orgID,
                    userName: username,
                    email: email,
                    phone: currentUser?.phone,
                    firstName: firstName,
                    lastName: lastName)
    }
    
    
    func setUserValues(user: User?) {
        guard let user = user else { return }
        currentUser = user
        self.username = user.userName ?? ""
        self.firstName = user.firstName ?? ""
        self.lastName = user.lastName ?? ""
        self.id = user.id
        self.email = user.email ?? ""
    }
}

struct SettingsView: View {
    
    @EnvironmentObject var userLoginState : UserLoginState
    @EnvironmentObject var viewModel : UserSettingsFormViewModel
    
    @ObservedObject var userImageLoader = UserImageLoader()
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
            .scaledToFit()
            .frame(width: 80, height: 80)
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
        
    func signOut() async {
        await authUtil.signOut()

        userLoginState.isSignedIn = false
    }
    
    func submit() async {
        UIApplication.shared.endEditing()
        isLoading = true

        let result = await self.userLoginState.updateUser(user: viewModel.allUserValues)

        self.isLoading = false
        switch result {
        case .success(let user):
            print("User successfully updated \(String(describing: user))")
            self.viewModel.setUserValues(user: user)
            self.viewModel.formIsDirty = false
        case .failure(let error):
            self.showAlert = true
            self.errorMessage = "An error occurred while updating user information."
            print(error)
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
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    
                    HStack {
                        Text("First Name:").font(.callout).bold()
                        TextField("First Name", text: self.$viewModel.firstName).textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    Section {
                        Button(action: {
                            Task {
                                await self.submit()
                            }
                        }) {
                            Text("Submit Changes")
                        }.disabled(!self.viewModel.enableSubmit)
                            .foregroundColor(self.viewModel.enableSubmit ? Color.lightTeal : Color.gray)
                    }
                    
                    Section {
                        Button(action: { Task{ await self.signOut() }}) {
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

/*
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/
