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
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.gray)
                .frame(maxHeight:250)
          
            UserImage()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:200)
                .shadow(radius: 10)
            
        }
    }
}

struct UserBanner_Previews: PreviewProvider {
    static var previews: some View {
        UserBanner()
    }
}
