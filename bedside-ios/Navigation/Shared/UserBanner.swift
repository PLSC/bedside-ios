//
//  UserBanner.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine

struct UserBanner: View {
    
    @EnvironmentObject var userLoginState : UserLoginState
    @State var image : Image? = nil
    @State var cancellable : AnyCancellable? = nil
    
    func downloadUserImage(user: User?) {
        guard let user = user, image == nil else { return }
        ImageLoader.sharedInstance.loadUserImage(withID: user.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.image = Image(uiImage: image)
                case .failure(let error):
                    print("failure downloading image: \(error)")
                }
            }
        }
    }
    
    //TODO: this should only run once.
    func initialize()  {
        cancellable = userLoginState.$currentUser.sink { user in
            self.downloadUserImage(user: user)
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.gray)
                .frame(maxHeight:250)
            if image == nil {
                Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:200)
                .clipShape(Circle())
                .shadow(radius: 10)
            } else {
                image!.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:200)
                .clipShape(Circle())
                .shadow(radius: 10)
            }
        }.onAppear(perform: initialize)
    }
}

struct UserBanner_Previews: PreviewProvider {
    static var previews: some View {
        UserBanner()
    }
}
