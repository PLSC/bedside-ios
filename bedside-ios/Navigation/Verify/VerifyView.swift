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
    
    var body: some View {
        NavigationView {
            VStack {
                UserHeader()
                ProcedureListView()
            }
            .navigationBarTitle(Text("Dr. \(userLoginState.currentUser?.lastName ?? "")"))
        }
    }
}

struct VerifyView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyView()
    }
}
