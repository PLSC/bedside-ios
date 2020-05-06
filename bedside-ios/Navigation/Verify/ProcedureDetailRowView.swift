//
//  ProcedureDetailRowView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProcedureDetailRowView: View {
    
    var procedure : Procedure
    
    var body: some View {
        HStack(alignment:.center) {
            Image(systemName: "bandage")
            VStack(alignment: .leading) {
                Text(procedure.name).bold()
                Text(procedure.description ?? "No description").lineLimit(nil)
            }
        }.padding()
    }
}

struct ProcedureDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureDetailRowView(procedure: proceduresTestData)
    }
}
