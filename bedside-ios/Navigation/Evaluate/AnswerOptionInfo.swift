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
                    HStack {
                        (Text(String(describing: option.assocValue)).bold() + Text(".")).padding()
                        Text(option.displayText).bold() + Text(" - ") + Text(option.description)
                    }.padding()
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
