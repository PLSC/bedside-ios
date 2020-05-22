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
        HStack{
            UserImage()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:75)
                .shadow(radius: 10)
            Spacer()
            VStack {
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
