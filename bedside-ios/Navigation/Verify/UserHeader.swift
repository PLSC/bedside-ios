//
//  UserHeader.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct UserHeader: View {
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    var body: some View {
        VStack {
            UserBanner()
            Group {
                Text("Dr. \(userLoginState.currentUser?.lastName?.capitalized ?? "") has been deemed competent to perform the following procedures under ") + Text("Indirect Supervision").font(.headline)
            }.padding([.leading, .trailing])
        }
    }
}

struct UserHeader_Previews: PreviewProvider {
    static var previews: some View {
        UserHeader().previewLayout(.sizeThatFits)
    }
}
