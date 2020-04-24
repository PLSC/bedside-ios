//
//  EvaluateView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct EvaluateView: View {
    
    @State var selectedProcedure : Procedure?
    @State var selectedRater : User?
    @State var procedureDate: Date = Date()
    @State var selectedAnswer : AnswerOption<Int>?
    
    
    @State var presentProcedures: Bool = false
    @State var presentRaterSelect: Bool = false
    @State var presentPerformanceEvaluation: Bool = false
    @State var presentEvalOverview: Bool = false
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    func procedureIsValid() -> Bool {
        return selectedProcedure != nil
    }
    
    func dateIsValid() -> Bool {
        return procedureDate < Date()
    }
    
    func raterIsValid() -> Bool {
        return selectedRater != nil
    }
    
    func selectPerformanceDisabled() -> Bool {
        return !procedureIsValid() || !dateIsValid() || !raterIsValid()
    }
    
    func canSubmitEval() -> Bool {
        return !selectPerformanceDisabled() && (selectedAnswer != nil)
    }
    
    func submitEvaluation() {
        let api = EvaluationAPI()
        api.createEvaluation(subject: userLoginState.currentUser!, rater: selectedRater!, procedure: selectedProcedure!, evaluationDate: procedureDate, ratingLevel: selectedAnswer!.assocValue) { (error) in
            print(error)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                UserHeaderSmall().padding()
                Form {
                    NavigationLink(
                        destination: ProcedureSelect(
                            selectedProcedure: $selectedProcedure,
                            isPresented: $presentProcedures),
                        isActive: $presentProcedures) {
                        ProcedureSelectRow(selectedProcedure: $selectedProcedure)
                    }
                    
                    DatePicker(selection: $procedureDate, in: ...Date()) {
                        Text("Date")
                    }.padding()
                    
                    NavigationLink(destination:
                        RaterSelect(users: previewRaters,
                                    selectedRater: $selectedRater,
                                    isPresented: $presentRaterSelect), isActive:$presentRaterSelect) {
                        RaterSelectRow(selectedRater: $selectedRater).padding()
                    }
                    
                    
                    NavigationLink(destination: PerformanceEvaluation(rater: $selectedRater, procedure: $selectedProcedure, selectedAnswer: $selectedAnswer, isPresented: $presentPerformanceEvaluation), isActive: $presentPerformanceEvaluation) {
                        
                        HStack {
                            Spacer(minLength: 35)
                            Button(action: {
                                print("Next button clicked.")
                            }) {
                                HStack {
                                    
                                    Text( (self.selectedAnswer != nil) ? "\(self.selectedAnswer?.displayText ?? "")" : "Select Performance" )
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                }
                            }
                            .padding()
                            .background(selectPerformanceDisabled() ? Color.gray : Color.blue)
                            .cornerRadius(10)
                            .disabled(selectPerformanceDisabled())
                            Spacer(minLength: 35)
                        }
                    }.disabled(selectPerformanceDisabled())
                    
                    HStack {
                        Spacer(minLength: 35)
                        Button(action:{
                            self.submitEvaluation()
                        }) {
                            Text("Submit")
                        }.disabled(!canSubmitEval())
                        .padding()
                        .background(selectPerformanceDisabled() ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        Spacer(minLength: 35)
                    }
                }
            }
            .navigationBarTitle("New Evaluation")
        }
    }
}

struct EvaluateView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluateView()
    }
}


