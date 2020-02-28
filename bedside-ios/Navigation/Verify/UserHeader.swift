//
//  UserHeader.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct UserHeader: View {
    var body: some View {
        VStack {
            HStack{
                Text("Dr. Lenox")
                .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.leading)
                Spacer()
            }
            
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
            Text("Dr. Lenox has been deemed competent to perform the following procedures under Indirect Supervision")
            .padding()
        }
    }
}

struct UserHeader_Previews: PreviewProvider {
    static var previews: some View {
        UserHeader().previewLayout(.sizeThatFits)
    }
}
