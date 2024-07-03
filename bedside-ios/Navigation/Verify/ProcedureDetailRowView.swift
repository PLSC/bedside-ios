//
//  ProcedureDetailRowView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProcedureDetailRowView: View {
    
    var procedure : Procedure?
    var isCertified : Bool?
    
    var body: some View {
        HStack(alignment:.center) {
            if isCertified ?? false {
                 Image(systemName: "checkmark.circle.fill").font(.system(size: 30)).padding(.trailing, 15).padding(.leading,10).foregroundColor(.lightTeal)
            } else {
                Image(systemName: "clock")
                   .font(.system(size:30))
                    .padding(.trailing, 15).padding(.leading,10)
                   .foregroundColor(Color.mustard)
            }
           
            VStack(alignment: .leading) {
                Text(procedure?.name ?? "").bold()
                Text(procedure?.description ?? "No description").lineLimit(nil)
            }
            Spacer()
        }
    }
}

struct ProcedureDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureDetailRowView(procedure: UITestModels.proceduresTestData[0], isCertified: true)
    }
}
