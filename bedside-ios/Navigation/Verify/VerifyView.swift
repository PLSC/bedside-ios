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
    
    func checkUserImage() {
        if UserProfileImage().profileImage == nil {
            showImagePicker = true
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                UserHeader()
                CertRecordListView()
            }
            .navigationBarTitle(Text("Dr. \(userLoginState.currentUser?.lastName ?? "")"))
        }.sheet(isPresented: $showImagePicker, content: { PhotoCaptureView(image: self.$image, showImagePicker: self.$showImagePicker)
        })
        .onAppear(perform: checkUserImage)
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView()
    }
}
