//
//  CertLogListView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct CertLogListView: View {
    var certLog : [EvaluationResponse]
    
    var body: some View {
        List(certLog.sorted(by: { (first, next) -> Bool in
            return first.evaluationDate > next.evaluationDate
        })) { evalResponse in
            EvalResponseListItem(evalResponse: evalResponse).padding()
        }
    }
}

struct CertLogListView_Previews: PreviewProvider {
    static var previews: some View {
        CertLogListView(certLog: [])
    }
}
