//
//  ActivityIndicator.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/7/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if Thread.current.isMainThread {
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        } else {
            DispatchQueue.main.async {
                isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
            }
        }
    }
}
