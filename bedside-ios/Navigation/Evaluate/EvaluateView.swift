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
    @State var presentProcedures: Bool = false
    @State var presentRaterSelect: Bool = false
    @State var procedureDate: Date = Date()
    @State var presentPerformanceEvaluation: Bool = false
    
    func procedureIsValid() -> Bool {
        return selectedProcedure != nil
    }
    
    func dateIsValid() -> Bool {
        return procedureDate < Date()
    }
    
    func raterIsValid() -> Bool {
        return true
    }
    
    func submitDisabled() -> Bool {
        return !procedureIsValid() || !dateIsValid() || !raterIsValid()
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
                    
                    NavigationLink(destination: RaterSelect(), isActive:$presentRaterSelect) {
                        RaterSelectRow(selectedRater: $selectedRater).padding()
                    }
                    
                    
                    NavigationLink(destination: PerformanceEvaluation(rater: $selectedRater, procedure: $selectedProcedure), isActive: $presentPerformanceEvaluation) {
                        
                        HStack {
                            Spacer(minLength: 35)
                            Button(action: {
                                print("Next button clicked.")
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Next")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(submitDisabled() ? Color.gray : Color.blue)
                            .cornerRadius(10)
                            .disabled(submitDisabled())
                            Spacer(minLength: 35)
                        }
                    }.disabled(submitDisabled())
                    
                    
                
                }
                
            }.navigationBarTitle("New Evaluation")
        }
    }
}

struct EvaluateView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluateView()
    }
}


