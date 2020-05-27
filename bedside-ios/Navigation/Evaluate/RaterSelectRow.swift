//
//  RaterSelectRow.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/14/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct RaterSelectRow: View {
    @Binding var selectedRater : User?
    var body: some View {
        HStack {
    
    
            if selectedRater == nil {
                Image(systemName: "circle")
                   .font(.system(size:30))
                   .foregroundColor(Color.gray)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color.green)
            }
            
            
           
            VStack(alignment: .leading, spacing: 5) {
                if (selectedRater != nil) {
                    Text("Rater:")
                        .font(.callout)
                    Text(selectedRater?.displayName ?? "")
                } else {
                    Text("Select a Rater")
                }
            }
            
            Spacer()
            
        }
    }
}

 var previewRater = User(id: "1", userName: "andy", email: "andy@example.org",
                         phone: "810-875-7864", firstName: "Andy",
                         lastName: "Lenox", npi: 1234, memberships: nil)

struct RaterSelectRow_Previews: PreviewProvider {
    
    static var previews: some View {
       
        Group {
            RaterSelectRow(selectedRater: .constant(nil))
                .previewDisplayName("No Selection")
            RaterSelectRow(selectedRater: .constant(previewRater))
            .previewDisplayName("Selected")
        }.previewLayout(.fixed(width: 300, height: 100))
        
    }
}
