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
    AnswerOption<Int>(id: 3, displayText: "Intermediate Performance", description: "Performance reflects an intermediate stage of development. Performance of procedural elements is variable but acceptable for the ammount of experience with this procedure. Not yet at the level expected for graduating residents.", assocValue: 3),
    AnswerOption<Int>(id: 4, displayText: "Practice-Ready Performance", description: "Resident is ready to perform this operation safely, effectively and independently assuming resident consistently performs procedure in this manner.", assocValue: 4),
    AnswerOption<Int>(id: 5, displayText: "Exceptional Performance", description: "One of the best performances I have ever seen. Above the level expected of graduating residents", assocValue: 5)
    ]

let performanceQuestion =
    Question(answerOptions: answerOptions,
               title: "Performance",
               questionText: "What was this resident's performance for the majority of the critical portion of this procedure?")

struct PerformanceEvaluation: View {
    
    @ObservedObject var evaluation : EvaluationFormData
    @State var showQuestionInfo = false
    @State var presentAttestation = false
    @State var isLoading = false
    
    var completion : (Bool) -> () = { _ in }
    
    @Environment(\.presentationMode) var presentationMode
    
    init(evaluation: EvaluationFormData, completion: @escaping (Bool) -> ()) {
        self.evaluation = evaluation
        self.completion = completion
    }
    
    func selectItem(index: Int) {
        print("Selected index: \(index), item: \(performanceQuestion.answerOptions[index])")
        evaluation.answer = performanceQuestion.answerOptions[index]
        self.presentAttestation = true
    }
    
    func submitEval() {
        self.presentationMode.wrappedValue.dismiss()
        completion(true)
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
        completion(false)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    UserHeaderSmall()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    HStack {
                        Text(performanceQuestion.questionText).padding()
                        Image(systemName: "info.circle").padding().onTapGesture {
                            print("info item tapped")
                            self.showQuestionInfo = true
                        }
                    }
                    
                    ProcedureSelectRow(selectedProcedure: $evaluation.procedure)
                    
                    ForEach(performanceQuestion.answerOptions.indices) {
                        idx in
                        Button(action: {
                             self.selectItem(index: idx)
                         }) {
                             Text(performanceQuestion.answerOptions[idx].displayText)
                                .frame(minWidth:0, maxWidth: .infinity)
                        }.buttonStyle(BigButtonStyle())
                    }
                    
                    Spacer().padding(.bottom, 50)
                    
                }.onAppear {
                    UITableView.appearance().separatorStyle = .none
                }.onDisappear {
                    UITableView.appearance().separatorStyle = .singleLine
                }
            }
            .navigationBarTitle("Select \(performanceQuestion.title)")
            .sheet(isPresented: self.$showQuestionInfo) { AnswerOptionInfo(question: performanceQuestion)
                    .accentColor(Color.lightTeal)
            }
            .alert(isPresented: self.$presentAttestation) {
                Alert(title: Text("Confirm"), message: Text(evaluation.attestation), primaryButton: .default(Text("Agree"), action: {
                    self.submitEval()
                }), secondaryButton: .destructive(Text("Disagree"), action: {
                    self.dismiss()
                }))
            }
            .navigationBarItems(trailing:
                           Button(action: {
                               self.presentationMode.wrappedValue.dismiss()
                           }) {
                              Image(systemName: "xmark")
                                .imageScale(.large)
                                .padding(.leading, 20)
                           })
        }
    }
}
