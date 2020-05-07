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
    
    //TODO: Put this in User
    func displayName(user: User) -> String {
        switch (user.firstName, user.lastName, user.email) {
        case let (firstName?, lastName?, _):
            return "\(firstName) \(lastName)"
        case let (nil, lastName?, _):
            return "Dr. \(lastName)"
        case let (nil, nil, email):
            return email
        default:
            return ""
        }
    }
    
    func selectRater(rater: User) {
        self.selectedRater = rater
        self.isPresented = false
    }
    
    func fetchRaters() {
        ratersViewModel.fetchRaters(organization: userLoginState.organizations.first!)
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
                        Text(self.displayName(user: user))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectRater(rater: user)
                    }
                }
            }
        }
        .navigationBarTitle("Select Rater")
        .navigationBarItems(trailing: Button(action: {
            print("add")
        }) {
            Image(systemName: "person.badge.plus")
        }).onAppear(perform:{
            self.fetchRaters()
        })
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
