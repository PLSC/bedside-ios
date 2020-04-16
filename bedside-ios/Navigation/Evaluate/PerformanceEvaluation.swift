//
//  PerformanceEvaluation.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/14/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct AnswerOption<T:Hashable> : Hashable, Identifiable {
    let id: Int
    let displayText : String
    let description: String
    let assocValue : T
}

struct Question<T:Hashable> {
    let answerOptions: [AnswerOption<T>]
    let title: String
    let questionText: String
}

let answerOptions = [
    AnswerOption<Int>(id: 1, displayText: "Unprepared / Critical Deficiency", description: "Poorly prepared to perform this procedure and/or included critical performance errors that endangered the safety of the patient or the outcome of the procedure", assocValue: 1),
    AnswerOption<Int>(id: 2, displayText: "Inexperienced w/ Procedure", description: "Resident appears inexperienced in performing this procedure. Frequent problems regarding technique, execution, smoothness, efficiency and forward planning", assocValue: 2),
    AnswerOption<Int>(id: 3, displayText: "Intermediate Performance", description: "description", assocValue: 3),
    AnswerOption<Int>(id: 4, displayText: "Practice-Ready Performance", description: "description", assocValue: 4),
    AnswerOption<Int>(id: 5, displayText: "Exceptional Performance", description: "description", assocValue: 5)
    ]

let performanceQuestion =
    Question(answerOptions: answerOptions,
               title: "Performance",
               questionText: "What was this resident's performance for the majority of the critical portion of this procedure?")

struct PerformanceEvaluation: View {
    
    @Binding var rater : User?
    @Binding var procedure: Procedure?
    
    func selectItem(index: Int) {
        print("Selected index: \(index), item: \(performanceQuestion.answerOptions[index])")
    }
    
    var body: some View {
            VStack {
                UserHeaderSmall()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                List {
                    HStack {
                        Text(performanceQuestion.questionText).padding()
                        Image(systemName: "info.circle").padding().onTapGesture {
                            print("info item tapped")
                        }
                    }
                    
                    ProcedureSelectRow(selectedProcedure: $procedure)
                    
                    ForEach(performanceQuestion.answerOptions.indices) {
                        idx in
                        Button(action: {
                             self.selectItem(index: idx)
                         }) {
                             Text(performanceQuestion.answerOptions[idx].displayText).frame(minWidth:0, maxWidth: .infinity)
                        }.buttonStyle(BigButtonStyle())
                    }
                    
                }.onAppear {
                    UITableView.appearance().separatorStyle = .none
                }.onDisappear {
                    UITableView.appearance().separatorStyle = .singleLine
                }
            }.navigationBarTitle("Select \(performanceQuestion.title)")
        
    }
}

struct PerformanceEvaluation_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceEvaluation(rater: .constant(nil), procedure: .constant(nil))
    }
}
