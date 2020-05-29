//
//  VerifyView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct VerifyView: View {
    
    @EnvironmentObject var userLoginState : UserLoginState
    @State var showImagePicker = false
    @State var image : UIImage? = nil
    @State var showImagePickerAlert = false
    
    var userProfileImage = UserProfileImage()
    
    func checkUserImage() {
        if !userProfileImage.storedProfileImage {
            showImagePickerAlert = true
        }
    }
    
    init() {
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                UserHeader()
                CertRecordListView()
            }
            .navigationBarTitle(Text("Dr. \(userLoginState.currentUser?.lastName ?? "")"), displayMode: .large)
        }.sheet(isPresented: $showImagePicker, content: { PhotoCaptureView(image: self.$image, showImagePicker: self.$showImagePicker)
        }).alert(isPresented: $showImagePickerAlert, content: {
            Alert(title: Text("User Image"),
                  message: Text("Please select an image of yourself."),
                  primaryButton: .default(Text("OK")) {
                    self.showImagePicker = true
                  },
                  secondaryButton: .destructive(Text("Later"), action: {
                    self.userProfileImage.storedProfileImage = true
                  }))
        })
        .onAppear(perform: checkUserImage)
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView()
    }
}
