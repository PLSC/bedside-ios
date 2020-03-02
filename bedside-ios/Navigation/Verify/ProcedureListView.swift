    //
//  ProcedureListView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProcedureListView: View {
    var body: some View {
        List {
            NavigationLink(destination: ProcedureDetailView()) {
                ProcedureRowView(completed: true)
            }
            
            NavigationLink(destination: ProcedureDetailView()) {
                ProcedureRowView(completed: true)
            }
            NavigationLink(destination: ProcedureDetailView()) {
                ProcedureRowView(completed: true)
            }
            NavigationLink(destination: ProcedureDetailView()) {
                ProcedureRowView(completed: false)
            }
        }
    }
}

struct ProcedureListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProcedureListView()
        }
    }
}
