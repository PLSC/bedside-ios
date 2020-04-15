//
//  ProcedureSelectRow.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProcedureSelectRow: View {
    @Binding var selectedProcedure : Procedure?
    var body: some View {
        HStack {
            if selectedProcedure != nil {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.green)
            } else {
                Image(systemName: "circle")
                    .font(.system(size:30))
                    .foregroundColor(Color.gray)
            }
            
            Text(selectedProcedure?.name ?? "Select Procedure")
            Spacer()
        }.padding()
    }
}


struct ProcedureSelectRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProcedureSelectRow(selectedProcedure: .constant(nil)).previewDisplayName("Unselected")
            ProcedureSelectRow(selectedProcedure: .constant(Procedure(id: "1", name: "Lap Chole", description: "Lap Chole")))
                .previewDisplayName("Selected")
        }.previewLayout(.fixed(width: 300, height: 50))
    }
}
