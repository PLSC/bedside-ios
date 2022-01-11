//
//  ProcedureSelect.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Amplify
import Combine

struct ProcedureSelect: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedProcedure : Procedure?
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    func selectProcedure(_ procedure: Procedure) {
        selectedProcedure = procedure
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func fetchProcedures() {
        guard let currentUser = userLoginState.currentUser else { return }
        self.userLoginState.procedureSelectViewModel.fetchProcedures(user: currentUser)
    }
    
    func doNothing() {
        return
    }
    
    var body: some View {
        return VStack {
            SearchBar(text: $userLoginState.procedureSelectViewModel.filterText, placeholder: "Search Procedures")
            List {
                Section(header: Text("Assigned Procedures")) {
                    ForEach(userLoginState.procedureSelectViewModel.searchFilteredAssignedProcedures, id: \.id) {
                        procedure in
                        HStack {
                            Text("\(procedure.name)")
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectProcedure(procedure)
                        }
                    }
                }
                Section(header: Text("Optional Procedures")) {
                    ForEach(userLoginState.procedureSelectViewModel.searchFilteredOptionalProcedures, id: \.id) {
                        procedure in
                        HStack {
                            Text("\(procedure.name)")
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectProcedure(procedure)
                        }
                    }
                }
            }.id(UUID())
        }.onAppear {
            self.fetchProcedures()
        }
        .navigationBarTitle("Procedures")
        
    }
}

