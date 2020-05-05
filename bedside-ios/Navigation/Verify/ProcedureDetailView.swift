//
//  ProcedureDetailView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProcedureDetailView: View {
    
    var certRecord: CertificationRecord
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProcedureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureDetailView(certRecord: certRecordTestData[0])
    }
}
