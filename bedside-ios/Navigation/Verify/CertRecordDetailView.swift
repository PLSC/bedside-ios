//
//  ProcedureDetailView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct CertRecordDetailView: View {
    
    var certRecord: CertificationRecord
    
    var body: some View {
        VStack(alignment: .leading) {
            UserHeaderSmall()
            ProcedureDetailRowView(procedure:certRecord.procedure, isCertified: certRecord.isCertified).padding(.leading, 20)
            CertLogListView(certLog: certRecord.certificationLog!)
        }
        .navigationBarTitle("Certification Record")
    }
}

struct ProcedureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CertRecordDetailView(certRecord: UITestModels.certRecordTestData[0])
    }
}
