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
        HStack {
            UserImage()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text("Dr. \(userLoginState.currentUser?.firstName?.capitalized ?? "") \(userLoginState.currentUser?.lastName?.capitalized ?? "")")
                Text("Surgical Trainee, \(userLoginState.organizations[0].title ?? "")")
            }
        }.padding()
    }
}

struct UserHeaderSmall_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderSmall()
    }
}
