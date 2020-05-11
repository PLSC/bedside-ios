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
    @State var users : [User]
    @State var presentNewRaterScreen : Bool = false
    @Binding var selectedRater : User?
    @Binding var isPresented : Bool
    
    @EnvironmentObject var userLoginState : UserLoginState
    
    @ObservedObject private var ratersViewModel : RatersViewModel = RatersViewModel()
    
    func substring(_ substring: String, inString: String?) -> Bool {
        guard let string = inString else { return false }
        return string.lowercased().contains(substring.lowercased())
    }
    
    //TODO: allow the filter search to create a filtered API request
    func userSearchFilter(_ user: User) -> Bool {
        guard let currentUserId = userLoginState.currentUser?.id else {
            print("No current user")
            return true
        }
        
        //Don't sure the current user.
        if user.id == currentUserId {
            return false
        }
        
        //Show all users if there is no search text.
        if searchText.isEmpty {
            return true
        }
        
        //Show users with substrings of names.
        let substringInFirst = substring(searchText, inString: user.firstName)
        let substringInLast = substring(searchText, inString: user.lastName)
                
        return substringInFirst || substringInLast
    }
    
    func selectRater(rater: User) {
        self.selectedRater = rater
        self.isPresented = false
    }
    
    func fetchRaters() {
        guard let org = userLoginState.organizations.first else {
            print("org not found for user: \(userLoginState.currentUser?.displayName ?? "No user")")
            return
        }
        
        ratersViewModel.fetchRaters(organization: org)
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Search Raters")
            List {
                ForEach(ratersViewModel.raters.filter(userSearchFilter), id: \.id) { user in
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
        }).sheet(isPresented: self.$presentNewRaterScreen) {
            NewRater(userSelectedCallback:{user in
                self.selectRater(rater: user)
            }, programs: self.userLoginState.organizations[0].programs!)
        }
    }
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

let previewRaters : [User] = [
    User(id: "1", email: "andy@simpl.org", firstName: "Andy", lastName: "Lenox"),
    User(id: "2", email: "sean@simpl.org", firstName: "Sean", lastName: "Loiselle"),
    User(id: "3", email: "greg@simpl.org", firstName: "Greg", lastName: "Wnuk")
]

struct RaterSelect_Previews: PreviewProvider {
    static var previews: some View {
        RaterSelect(users: previewRaters,
                    selectedRater: .constant(nil),
                    isPresented: .constant(true))
    }
}
