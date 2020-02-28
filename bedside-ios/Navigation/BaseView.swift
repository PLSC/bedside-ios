//
//  BaseView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct BaseView: View {
    
    var body: some View {
        TabView {
            VerifyView()
                .tabItem {
                    Image(systemName: "checkmark.shield")
                    Text("Verify")
                }
            EvaluateView()
                .tabItem {
                    Image(systemName: "gauge")
                    Text("Evaluate")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .font(.headline)
        .navigationBarBackButtonHidden(true)
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
