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
    
    func fetchProcedures() async {
        guard let currentUser = userLoginState.currentUser else { return }

        await self.userLoginState.procedureSelectViewModel.fetchProcedures(user: currentUser)
    }
    
    fileprivate func procedureListView() -> some View {
        return List {
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
            Section(header:Text("Missing Procedures?")) {
                HStack {
                    Text("Please contact your program administrator to add missing procedure names")
                }
                .contentShape(Rectangle())
            }
        }
        .id(UUID())
    }
    
    var body: some View {
        return VStack {
            if #available(iOS 15, *) {
                procedureListView()
                    .searchable(text: $userLoginState.procedureSelectViewModel.filterText)
            } else {
                SearchBar(text: $userLoginState.procedureSelectViewModel.filterText, placeholder: "Search Procedures")
                procedureListView()
            }
        }.onAppear {
            Task {
                await self.fetchProcedures()
            }
        }
        .onDisappear {
            userLoginState.procedureSelectViewModel.filterText = ""
        }
        .navigationBarTitle("Procedures")
    }
}

