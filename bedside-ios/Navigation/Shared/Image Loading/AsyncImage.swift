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
    
    var isCircle : Bool = true
    
    init(isCircle: Bool = true) {
        self.isCircle = isCircle
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                if self.isCircle {
                    Image(uiImage: loader.image!)
                    .resizable()
                    .clipShape(
                        Circle()
                    )
                } else {
                    Image(uiImage: loader.image!)
                    .resizable()
                    .clipped()
                }
                
            } else {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
    }
}
