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
    @State var showEmptyView = true
    
    var userProfileImage = UserProfileImage()
    
    func checkUserImage() async {
        await userLoginState.fetchCurrentUserCertRecords()
        if !userProfileImage.storedProfileImage {
            showImagePickerAlert = true
        }
    }
    
    @ViewBuilder
    var certRecordContainer : some View {
        if showEmptyView {
            EmptyCertRecordView()
        } else {
            CertRecordListView(viewModel: userLoginState.certRecordViewModel)
        }
    }
    
    var body: some View {
         NavigationView {
            VStack(alignment: .leading) {
                UserBanner()
                certRecordContainer
            }
            .navigationBarTitle("Verify", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                NotificationCenter.default.post(name: Notification.Name("Refresh.CertRecords"), object: nil)
                }){
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
                    .padding(.trailing, 20)
            }, trailing: Button(action: {
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
        .onAppear {
            Task {
                await checkUserImage()
                await userLoginState.fetchCurrentUserCertRecords()
            }
        }
        .onReceive(self.userLoginState.certRecordViewModel.$showEmptyView) { (show) in
            self.showEmptyView = show
        }
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView()
    }
}

struct EmptyCertRecordView: View {
    @EnvironmentObject var userLoginState : UserLoginState

    var body: some View {
        LoadingView(isShowing: $userLoginState.certRecordViewModel.loading) {
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
}
