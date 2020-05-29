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
                .foregroundColor(Color.lightTeal)
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

struct ProcedureRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CertRecordRowView(certificationRecord: UITestModels.certRecordTestData[0])
            CertRecordRowView(certificationRecord: UITestModels.certRecordTestData[1])
            
        }.previewLayout(.fixed(width: 300, height: 50))
    }
}
