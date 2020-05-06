//
//  ProcedureRowView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct CertRecordRowView: View {
    
    var certificationRecord: CertificationRecord
    
    var body: some View {
        HStack {
            if (certificationRecord.isCertified) {
                Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(Color.green)
            } else {
                Image(systemName: "circle")
                    .font(.system(size:30))
                    .foregroundColor(Color.gray)
            }
            
            Text("\(certificationRecord.procedure.name)")
            Spacer()
        }.padding()
    }
}

let proceduresTestData = Procedure(id: "1", name: "Central Line", description: "A line that goes into your center")

let certRecordTestData = [
    CertificationRecord(id: "1", procedure: proceduresTestData, isCertified: true, certificationMethod: nil, totalProcedureEvals: 2, certificationLog: nil),
    CertificationRecord(id: "2", procedure: proceduresTestData, isCertified: false, certificationMethod: nil, totalProcedureEvals: 3, certificationLog: nil)
]

struct ProcedureRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CertRecordRowView(certificationRecord: certRecordTestData[0])
            CertRecordRowView(certificationRecord: certRecordTestData[1])
            
        }.previewLayout(.fixed(width: 300, height: 50))
    }
}
