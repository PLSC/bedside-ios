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
            VStack(alignment: .leading, spacing: 5) {
                if (selectedRater != nil) {
                    Text("Evaluator:")
                        .font(.callout)
                    Text("\(selectedRater?.firstName ?? "first name") \(selectedRater?.lastName ?? "last name")")
                } else {
                    Text("Select a Rater")
                }
            }
            
            Spacer()
            
            if (selectedRater != nil) {
                Image("andy")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(maxHeight:60)
                   .clipShape(Circle())
                   .shadow(radius: 10)
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(maxHeight:60)
                    .foregroundColor(.gray)
                    .font(Font.callout.weight(.thin))
                    
            }
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
