//
//  LoadingView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/7/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var progress: Binding<Float>?
    
    var content: () -> Content
    
    init(isShowing: Binding<Bool>,
         progress: Binding<Float>? = nil,
         content: @escaping () -> Content) {
        self._isShowing = isShowing
        self.progress = progress
        self.content = content
    }
    
    var progressView : some View {
        return Text("\(String(format: "%.2f", progress?.wrappedValue ?? 0.0))")
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                    if self.progress != nil {
                        self.progressView
                    }
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
