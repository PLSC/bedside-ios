//
//  PerformanceEvaluation.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/14/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct InstrumentItem<T:Hashable> : Hashable, Identifiable {
    let id: Int
    let displayText : String
    let description: String
    let assocValue : T
}

struct Instrument<T:Hashable> {
    let items: [InstrumentItem<T>]
    let instrumentTitle: String
    let usageDescription: String
}

let instrumentItems = [
    InstrumentItem<Int>(id: 1, displayText: "Unprepared / Critical Deficiency", description: "Poorly prepared to perform this procedure and/or included critical performance errors that endangered the safety of the patient or the outcome of the procedure", assocValue: 1),
    InstrumentItem<Int>(id: 2, displayText: "Inexperienced w/ Procedure", description: "Resident appears inexperienced in performing this procedure. Frequent problems regarding technique, execution, smoothness, efficiency and forward planning", assocValue: 2),
    InstrumentItem<Int>(id: 3, displayText: "Intermediate Performance", description: "description", assocValue: 3),
    InstrumentItem<Int>(id: 4, displayText: "Practice-Ready Performance", description: "description", assocValue: 4),
    InstrumentItem<Int>(id: 5, displayText: "Exceptional Performance", description: "description", assocValue: 5)
    ]

let performanceInstrument =
    Instrument(items: instrumentItems,
               instrumentTitle: "Performance",
               usageDescription: "What was this resident's performance for the majority of the critical portion of this procedure?")

struct PerformanceEvaluation: View {
    
    @Binding var rater : User?
    @Binding var procedure: Procedure?
    
    func selectItem(index: Int) {
        print("Selected index: \(index), item: \(performanceInstrument.items[index])")
    }
    
    var body: some View {
            VStack {
                UserHeaderSmall()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                List {
                    HStack {
                        Text(performanceInstrument.usageDescription).padding()
                        Image(systemName: "info.circle").padding().onTapGesture {
                            print("info item tapped")
                        }
                    }
                    
                    ProcedureSelectRow(selectedProcedure: $procedure)
                    
                    ForEach(performanceInstrument.items.indices) {
                        idx in
                        Button(action: {
                             self.selectItem(index: idx)
                         }) {
                             Text(performanceInstrument.items[idx].displayText).frame(minWidth:0, maxWidth: .infinity)
                        }.buttonStyle(BigButtonStyle())
                    }
                    
                }.onAppear {
                    UITableView.appearance().separatorStyle = .none
                }.onDisappear {
                    UITableView.appearance().separatorStyle = .singleLine
                }
            }.navigationBarTitle("Select \(performanceInstrument.instrumentTitle)")
        
    }
}

struct PerformanceEvaluation_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceEvaluation(rater: .constant(nil), procedure: .constant(nil))
    }
}
