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
    @State var presentProcedures: Bool = false
    @State var procedureDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                UserBanner()
                Form {
                    NavigationLink(
                        destination: ProcedureSelect(
                            selectedProcedure: $selectedProcedure,
                            isPresented: $presentProcedures),
                        isActive: $presentProcedures) {
                        ProcedureSelectRow(selectedProcedure: $selectedProcedure)
                    }
                    DatePicker(selection: $procedureDate) {
                        Text("Date")
                    }.padding()
                    
                }.navigationBarTitle("New Evaluation")
            }
        }
    }
}

struct EvaluateView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluateView()
    }
}


