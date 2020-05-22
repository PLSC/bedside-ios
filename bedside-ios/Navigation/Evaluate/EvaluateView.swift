//
//  EvaluateView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine

struct EvaluateView: View {
    @ObservedObject var evaluation : EvaluationFormData = EvaluationFormData()
    
    @State var presentProcedures: Bool = false
    @State var presentRaterSelect: Bool = false
    @State var presentPerformanceEvaluation: Bool = false
    @State var presentEvalOverview: Bool = false
    
    @State var isLoading: Bool = false
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    func submitEvaluation() {
        self.isLoading = true
        evaluation.submitEvaluation { error in
            if error == nil {
               self.evaluation.reset()
               self.userLoginState.fetchCurrentUserCertRecords()
            }
            self.isLoading = false
        }
    }
    
    var procedureSelectRow: some View {
        NavigationLink(
            destination: ProcedureSelect(
                selectedProcedure: self.$evaluation.procedure,
                isPresented: self.$presentProcedures),
            isActive: self.$presentProcedures) {
                ProcedureSelectRow(selectedProcedure: self.$evaluation.procedure)
        }
    }
    
    var procedureDatePicker: some View {
        DatePicker(selection: self.$evaluation.procedureDate, in: self.evaluation.oldestValidEvalDate()...Date()) {
            Text("Date")
        }.padding()
    }
    
    var raterSelectRow: some View {
        NavigationLink(destination:
            RaterSelect(selectedRater: self.$evaluation.rater,
                        isPresented: self.$presentRaterSelect), isActive:self.$presentRaterSelect) {
                            RaterSelectRow(selectedRater: self.$evaluation.rater).padding()
        }
    }
    
    var performanceEvaluationRow: some View {
        NavigationLink(destination:
        PerformanceEvaluation(rater: self.$evaluation.rater,
                              procedure: self.$evaluation.procedure,
                              selectedAnswer: self.$evaluation.answer,
                              isPresented: self.$presentPerformanceEvaluation),
                       isActive: self.$presentPerformanceEvaluation) {
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
    }
    
    var submitButtonRow: some View {
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
            .background(self.evaluation.evalIsValid ? Color.blue : Color.gray)
            .cornerRadius(10)
            .disabled(!self.evaluation.evalIsValid)
            Spacer(minLength: 35)
        }
    }
    
    func initialize() {
        evaluation.subject = userLoginState.currentUser
    }
    
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            NavigationView {
                VStack {
                    UserHeaderSmall().padding()
                    Form {
                        self.procedureSelectRow
                        self.procedureDatePicker
                        self.raterSelectRow
                        self.performanceEvaluationRow
                        self.submitButtonRow
                    }
                }
                .navigationBarTitle("New Evaluation")
            }.onAppear(perform: self.initialize)
        }
        
    }
}

struct EvaluateView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluateView()
    }
}


