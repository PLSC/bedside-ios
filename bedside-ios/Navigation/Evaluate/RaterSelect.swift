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
    
    func substring(_ substring: String, inString: String?) -> Bool {
        var substringInString = false
        if let sub = inString {
            substringInString = sub
                .lowercased()
                .contains(substring.lowercased())
        }
        return substringInString
    }
    
    func userSearchFilter(_ user: User) -> Bool {
        if searchText.isEmpty {
            return true
        }
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
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Search Raters")
            List {
                ForEach(users.filter(userSearchFilter), id: \.id) { user in
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
