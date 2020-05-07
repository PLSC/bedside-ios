//
//  EvaluateView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct EvaluateView: View {
    @ObservedObject var evaluation : EvaluationFormData = EvaluationFormData()
    
    
    @State var presentProcedures: Bool = false
    @State var presentRaterSelect: Bool = false
    @State var presentPerformanceEvaluation: Bool = false
    @State var presentEvalOverview: Bool = false
    
    @State var isLoading: Bool = false
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    func canSubmitEval() -> Bool {
        return self.evaluation.isValid()
    }
    
    func oldestValidEvalDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.hour = -72
        return Calendar.current.date(byAdding: dateComponents, to: Date())!
    }
    
    func submitEvaluation() {
        let api = EvaluationAPI()
        self.isLoading = true
        api.createEvaluation(subject: userLoginState.currentUser!,
                             rater: evaluation.rater!,
                             procedure: evaluation.procedure!,
                             procedureDate: evaluation.procedureDate,
                             ratingLevel: evaluation.answer!.assocValue) { (error) in
            if error == nil {
                self.evaluation.reset()
                self.userLoginState.fetchCurrentUserCertRecords()
            }
            self.isLoading = false
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            NavigationView {
                VStack {
                    UserHeaderSmall().padding()
                    Form {
                        NavigationLink(
                            destination: ProcedureSelect(
                                selectedProcedure: self.$evaluation.procedure,
                                isPresented: self.$presentProcedures),
                            isActive: self.$presentProcedures) {
                                ProcedureSelectRow(selectedProcedure: self.$evaluation.procedure)
                        }
                        
                        DatePicker(selection: self.$evaluation.procedureDate, in: self.oldestValidEvalDate()...Date()) {
                            Text("Date")
                        }.padding()
                        
                        NavigationLink(destination:
                            RaterSelect(users: previewRaters,
                                        selectedRater: self.$evaluation.rater,
                                        isPresented: self.$presentRaterSelect), isActive:self.$presentRaterSelect) {
                                            RaterSelectRow(selectedRater: self.$evaluation.rater).padding()
                        }
                        
                        
                        NavigationLink(destination: PerformanceEvaluation(rater: self.$evaluation.rater, procedure: self.$evaluation.procedure, selectedAnswer: self.$evaluation.answer, isPresented: self.$presentPerformanceEvaluation), isActive: self.$presentPerformanceEvaluation) {
                            
                            HStack {
                                Spacer(minLength: 35)
                                Button(action: {
                                    print("Next button clicked.")
                                }) {
                                    HStack {
                                        
                                        Text( (self.evaluation.answer != nil) ? "\(self.evaluation.answer?.displayText ?? "")" : "Select Performance" )
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                    }
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                Spacer(minLength: 35)
                            }
                        }
                        
                        HStack {
                            Spacer(minLength: 35)
                            Button(action:{
                                self.submitEvaluation()
                            }) {
                                Text("Submit")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            Spacer(minLength: 35)
                        }
                    }
                }
                .navigationBarTitle("New Evaluation")
            }
        }
        
    }
}

struct EvaluateView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluateView()
    }
}


