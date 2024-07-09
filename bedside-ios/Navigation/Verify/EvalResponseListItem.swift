//
//  EvalResponseListItem.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/7/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct EvalResponseListItem: View {
    
    var evalResponse: EvaluationResponse
    
    var displayDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from:evalResponse.evaluationDate.foundationDate)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                Text(evalResponse.rater.displayName)
                Spacer()
                Text(displayDate).foregroundColor(.gray)
            }
            HStack {
                Image(systemName: "dial")
                Text("\(evalResponse.ratingDisplayText ?? "Invalid Rating Level")") + Text(" - \(evalResponse.ratingLevel ?? 0)").foregroundColor(.gray)
            }
        }
        
        
    }
}

struct EvalResponseListItem_Previews: PreviewProvider {
    static var previews: some View {
        EvalResponseListItem(evalResponse: UITestModels.evalResponseTestData[0])
    }
}
