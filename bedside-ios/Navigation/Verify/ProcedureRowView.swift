//
//  ProcedureRowView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProcedureRowView: View {
    
    @State var completed : Bool
    
    var body: some View {
        HStack {
            if (completed) {
                Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(Color.green)
            } else {
                Image(systemName: "circle")
                    .font(.system(size:30))
                    .foregroundColor(Color.gray)
            }
            
            Text("Central Line")
            Spacer()
        }.padding()
    }
}

struct ProcedureRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProcedureRowView(completed: true)
            ProcedureRowView(completed: false)
        }.previewLayout(.fixed(width: 300, height: 50))
    }
}
