//
//  RaterSelect.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct RaterSelect: View {
    @State private var searchText = ""
    @State var presentNewRaterScreen : Bool = false
    @Binding var selectedRater : User?
    @Binding var isPresented : Bool
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    @ObservedObject private var ratersViewModel = RatersViewModel(filterIds:[])
    
    func selectRater(rater: User) {
        self.selectedRater = rater
        self.isPresented = false
    }
    
    //TODO: Fetch org id from user.
    func fetchRaters() {
        guard let org = userLoginState.currentUser?.orgId else {
            print("org not found for user: \(userLoginState.currentUser?.displayName ?? "No user")")
            return
        }
        
        ratersViewModel.fetchRaters(orgId: org)
    }
    
    func filterCurrentUser() {
        if let id = self.userLoginState.currentUser?.id {
            self.ratersViewModel.filterIds = [id]
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $ratersViewModel.filterText, placeholder: "Search Raters")
            List {
                ForEach(ratersViewModel.filteredUsers, id: \.id) { user in
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(maxHeight:60)
                            .foregroundColor(.gray)
                            .font(Font.callout.weight(.thin))
                        Text(user.displayName)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectRater(rater: user)
                    }
                }
                
                HStack(alignment: .center) {
                    Image(systemName: "person.badge.plus").foregroundColor(.blue)
                    Text("Add a Rater")
                    Spacer()
                }
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
        }).onAppear(perform:{
            self.fetchRaters()
            self.filterCurrentUser()
        }).sheet(isPresented: self.$presentNewRaterScreen) {
            NewRater(newRaterViewModel:
                NewRaterViewModel(
                    programs:self.userLoginState.organizations[0].programs!,
                    orgId: self.userLoginState.currentUser?.orgId ?? "",
                    userCreatedCallback: {
                        user in
                        self.selectRater(rater: user)
                }))
        }
    }
}

struct RaterSelect_Previews: PreviewProvider {
    static var previews: some View {
        RaterSelect(selectedRater: .constant(nil),
                    isPresented: .constant(true))
    }
}
