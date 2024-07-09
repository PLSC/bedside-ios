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
    
    @State var presentEvaluation: Bool = false
    @State var presentEvalHandoffAlert: Bool = false
    @State var presentOfflineAlert: Bool = false
    
    @State private var viewPresented: String? = nil
    
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    @EnvironmentObject var userLoginState : UserLoginState
    @EnvironmentObject private var loader: UserImageLoader
    @EnvironmentObject var networkStatusObserver : NetworkStatusObserver
    
    func submit() async {
        isLoading = true

        let error = await evaluation.submitEvaluation()

        self.isLoading = false
        self.evaluation.reset()
        await self.userLoginState.fetchCurrentUserCertRecords()

        if error != nil {
            self.errorMessage = "There was an error submitting your evaluation. Please try again later."
        } else {
            self.errorMessage = ""
            NotificationCenter.default.post(name: TabBarEvents.change, object: Tab.verify)
        }
    }
    
    func reset() {
        evaluation.reset()
    }
    
    func nextButtonPressed() {
        switch networkStatusObserver.networkStatus {
        case .online:
            self.presentEvalHandoffAlert = true
        case .offline:
            self.presentOfflineAlert = true
        }
        
    }
    
    func handoffAlertDismissed() {
        self.presentEvaluation = true
    }
    
    var procedureSelectRow: some View {
        NavigationLink(
            destination: ProcedureSelect(selectedProcedure: self.$evaluation.procedure),
            tag: "ProcedureSelect",
            selection: self.$viewPresented) {
            ProcedureSelectRow(selectedProcedure: self.$evaluation.procedure)
        }
    }
    
    var procedureDatePicker: some View {
        DatePicker(selection: self.$evaluation.procedureDate, in: self.evaluation.oldestValidEvalDate()...Date()) {
            Text("Date")
        }.padding()
    }
    
    var raterSelectRow: some View {
        NavigationLink(
            destination:
                RaterSelect(selectedRater: self.$evaluation.rater),
            tag: "RaterSelect",
            selection: self.$viewPresented) {
                RaterSelectRow(selectedRater: self.$evaluation.rater).padding()
        }
    }
    
    var nextButton: some View {
        Button(action: {
            self.nextButtonPressed()
          }) {
              HStack {
                  Text("Next")
                      .font(.headline)
              }
          }
        .alert(isPresented: self.$presentOfflineAlert) {
            Alert(title: Text("Offline"), message: Text("You appear to be offline. Please try again when you have an internet connection."), dismissButton: .cancel(Text("OK")))
        }
        .padding()
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .disabled(!self.evaluation.readyForEvaluation)
        
    }
    
    func initialize() {
        evaluation.subject = userLoginState.currentUser
    }
    
    var body: some View {
            NavigationView {
                Form {
                    if !self.errorMessage.isEmpty {
                        Text(self.errorMessage).foregroundColor(.red)
                    }
                    UserHeaderSmall()
                    
                    self.procedureDatePicker
                    self.procedureSelectRow
                    self.raterSelectRow
                    Section {
                        self.nextButton
                    }.listRowBackground(
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundColor(self.evaluation.readyForEvaluation ? Color.lightTeal : Color.gray)
                            .padding([.leading, .trailing], 10)
                    )
                }
                .navigationBarTitle("New Evaluation")
                .onAppear(perform: self.initialize)
            }
            .sheet(isPresented: self.$presentEvaluation) {
                PerformanceEvaluation(evaluation: self.evaluation) {
                    complete in
                    if complete {
                        Task {
                            await self.submit()
                        }
                    } else {
                        self.reset()
                    }
                }
                .environmentObject(self.userLoginState)
                .accentColor(Color.lightTeal)
            }.alert(isPresented: self.$presentEvalHandoffAlert) {
                Alert(title: Text("Handoff"),
                      message: Text("Please hand your phone to the rater you selected."),
                      dismissButton: .default(Text("OK").foregroundColor(Color.lightTeal), action: { self.handoffAlertDismissed() }) )
            }
    }
}

struct EvaluateView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluateView()
    }
}


