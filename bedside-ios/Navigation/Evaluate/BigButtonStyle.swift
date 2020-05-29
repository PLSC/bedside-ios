//
//  BigButtonStyle.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/15/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct BigButtonStyle: ButtonStyle {
    var enabled : Bool = true
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(enabled ? Color.lightTeal : Color.gray)
            .foregroundColor(Color.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
