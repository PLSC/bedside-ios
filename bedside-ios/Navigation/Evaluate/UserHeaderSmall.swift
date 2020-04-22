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
            Image("andy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:75)
                .clipShape(Circle())
                .shadow(radius: 10)
            Spacer()
            VStack {
                Text("Dr. \(userLoginState.currentUser?.firstName?.capitalized ?? "") \(userLoginState.currentUser?.lastName?.capitalized ?? "")")
                Text("Surgical Trainee, U of M")
            }
        }
         
    }
}

struct UserHeaderSmall_Previews: PreviewProvider {
    static var previews: some View {
        UserHeaderSmall()
    }
}
