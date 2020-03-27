//
//  ProgramSelect.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ProgramSelect: View {
    @State var programs : [Program] = []
    
    @Binding var selectedProgram : Program?
    
    @Binding var isPresented : Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProgramSelect_Previews: PreviewProvider {
    static var previews: some View {
        ProgramSelect(programs: [], selectedProgram: .constant(nil), isPresented: .constant(true))
    }
}
