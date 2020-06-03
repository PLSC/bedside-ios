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
    
    var body: some View {
        let showRecords = !userLoginState.certificationRecords.isEmpty
        
        return NavigationView {
            VStack(alignment: .leading) {
                UserBanner()
                if showRecords {
                    CertRecordListView()
                } else {
                    EmptyCertRecordView()
                }
            }
            .navigationBarTitle("Verify", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                NotificationCenter.default.post(name: TabBarEvents.change, object: Tab.evaluate)
            }) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding(.leading, 20)
            })
        }
        .sheet(isPresented: $showImagePicker,
               content: {
                PhotoCaptureView(image: self.$image, showImagePicker: self.$showImagePicker)
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

struct EmptyCertRecordView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No Evaluations").font(.headline).foregroundColor(.secondary)
            Button(action: {
                NotificationCenter.default.post(name: TabBarEvents.change, object: Tab.evaluate)
            }) {
                Text("New Evaluation")
            }.buttonStyle(BigButtonStyle())
                .frame(minWidth:0, maxWidth: .infinity)
                .padding(.horizontal, 20)
            Spacer()
        }
    }
}
