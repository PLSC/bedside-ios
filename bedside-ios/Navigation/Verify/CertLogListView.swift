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
        List(certLog.sorted(by: { $0.evaluationDate > $1.evaluationDate })
                .map(IdentifiableEvaluationResponse.init)) { identifiableEvalResponse in
            EvalResponseListItem(evalResponse: identifiableEvalResponse.evaluationResponse).padding()
        }
    }
}

struct IdentifiableEvaluationResponse: Identifiable {
    let id: String
    let evaluationResponse: EvaluationResponse

    init(evaluationResponse: EvaluationResponse) {
        self.id = evaluationResponse.id
        self.evaluationResponse = evaluationResponse
    }
}

struct CertLogListView_Previews: PreviewProvider {
    static var previews: some View {
        CertLogListView(certLog: [])
    }
}
