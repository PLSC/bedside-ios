//
//  UserBanner.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct UserBanner: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(maxHeight:250)
            Image("andy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:200)
                .clipShape(Circle())
                .shadow(radius: 10)
            
        }
    }
}

struct UserBanner_Previews: PreviewProvider {
    static var previews: some View {
        UserBanner()
    }
}
