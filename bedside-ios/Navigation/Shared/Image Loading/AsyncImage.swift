//
//  AsyncImage.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/19/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct UserImage : View {
    @ObservedObject private var loader: UserImageLoader = UserImageLoader()

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
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
    }
}
