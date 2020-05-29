//
//  AnswerOptionInfo.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/17/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct AnswerOptionInfo<T:Hashable>: View {
    
    var question : Question<T>
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(question.answerOptions, id: \.id) { option in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(String(describing:option.assocValue)).").font(.headline)
                            Text(option.displayText).font(.headline)
                        }
                        Spacer()
                        Text(option.description).font(.caption)
                    }
                        
                    
                }
            }
            .navigationBarTitle(question.title)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                   Image(systemName: "xmark")
                })
        }
    }
}

struct AnswerOptionInfo_Previews: PreviewProvider {
    static var previews: some View {
        AnswerOptionInfo(question: performanceQuestion)
    }
}
