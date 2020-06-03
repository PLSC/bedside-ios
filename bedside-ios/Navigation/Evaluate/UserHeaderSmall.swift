//
//  UserHeaderSmall.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/15/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct UserHeaderSmall: View {
    @EnvironmentObject var userLoginState : UserLoginState
    
    var body: some View {
        
        let orgTitle = userLoginState.organizations.reduce("") {result, next in return "\(next.title ?? "")"}
        return HStack {
            UserImage()
                .scaledToFit()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                Text("Dr. \(userLoginState.currentUser?.firstName?.capitalized ?? "") \(userLoginState.currentUser?.lastName?.capitalized ?? "")").bold()
                Text("Surgical Trainee, \(orgTitle)")
            }
        }
    }
}

struct UserHeaderSmall_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderSmall()
    }
}
