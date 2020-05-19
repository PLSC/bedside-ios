//
//  AsyncImage.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/19/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct AsyncUserImage<Placeholder: View>: View {
    @ObservedObject private var loader: UserImageLoader
    private let placeholder: Placeholder?
    
    init(id: User.ID, placeholder: Placeholder? = nil) {
        loader = UserImageLoader(userId: id)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
