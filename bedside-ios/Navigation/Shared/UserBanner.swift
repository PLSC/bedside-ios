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
    @State var orgTitle = ""
    
    var body: some View {
        let organizationTitle = userLoginState.organizations.reduce("") { (result, organization) in
            return (organization.title ?? "")
        }
        
        let programString = userLoginState.currentUser?.memberships?.reduce("", { (result, membership) in
            return "\(membership.program.name) "
        })
        
        return HStack {
            UserImage(isCircle: false)
                .scaledToFit()
                .frame(maxWidth: 200)
            VStack(alignment:.leading) {
                Text("\(userLoginState.currentUser?.displayName ?? "")")
                    .font(.system(.title))
                    .fontWeight(.heavy)
                Text("\(programString ?? "")Resident")
                    .font(.system(.caption))
                    .foregroundColor(.gray)
                Text("at \(organizationTitle)")
                    .font(.system(.caption))
                    .foregroundColor(.gray)
            }.padding(.horizontal)
        }
    }
}

struct UserBanner_Previews: PreviewProvider {
    static var previews: some View {
        UserBanner()
    }
}
