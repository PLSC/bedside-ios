//
//  RaterSelect.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct RaterRow: View {
    var user: User
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(maxHeight:60)
                .foregroundColor(.gray)
                .font(Font.callout.weight(.thin))
            Text(user.displayName)
            Spacer()
        }
    }
}

struct AddRaterRow: View {
    var body: some View {
        HStack(alignment: .center) {
           Image(systemName: "person.badge.plus").foregroundColor(.blue)
           Text("Add a Rater")
           Spacer()
       }
    }
}

struct RaterSelect: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var presentNewRaterScreen : Bool = false
    @Binding var selectedRater : User?
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    func selectRater(rater: User) {
        self.selectedRater = rater
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func fetchRaters() async {

        guard let org = userLoginState.currentUser?.orgID else {
            print("org not found for user: \(userLoginState.currentUser?.displayName ?? "No user")")
            return
        }
        
        await userLoginState.ratersViewModel.fetchRaters(orgId: org)
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $userLoginState.ratersViewModel.filterText, placeholder: "Search Raters")
            List {
                ForEach(userLoginState.ratersViewModel.filteredUsers, id: \.id) { user in
                    RaterRow(user: user)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectRater(rater: user)
                    }
                }
                
                AddRaterRow()
                    .contentShape(Rectangle())
                    .padding()
                    .onTapGesture {
                        self.presentNewRaterScreen = true
                    }
            }
        }
        .navigationBarTitle("Select Rater")
        .navigationBarItems(trailing: Button(action: {
            self.presentNewRaterScreen = true
        }) {
            Image(systemName: "person.badge.plus")
                .imageScale(.large)
                .padding(.leading, 20)
        }).onAppear(perform:{
            Task {
                await self.fetchRaters()
            }
        }).sheet(isPresented: self.$presentNewRaterScreen) {
            NewRater(viewModel:
                NewRaterViewModel(
                    orgId: self.userLoginState.currentUser?.orgID ?? "",
                    currentUser: self.userLoginState.currentUser ?? nil,
                    userCreatedCallback: {
                        user in
                        self.selectRater(rater: user)
                })).accentColor(Color.lightTeal)
        }
    }
}

