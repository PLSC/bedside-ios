//
//  ContentView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("Hello, World!")
        }
        .navigationBarTitle(Text("SwiftUI"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
