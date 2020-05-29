//
//  BaseView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

extension BaseView {
    class TabBarViewModel : ObservableObject {
        @Published var selectedTab : Tab = .verify
        var cancellables : Set<AnyCancellable> = []
        
        init() {
            NotificationCenter.default
            .publisher(for: TabBarEvents.change)
            .sink { (notification) in
                guard let tab = notification.object as? Tab else { return }
                self.selectedTab = tab
            }
            .store(in: &cancellables)
        }
    }
}

struct BaseView: View {
    
    @ObservedObject var viewModel = TabBarViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            VerifyView()
                .tabItem {
                    Image(systemName: "checkmark.shield")
                    Text("Verify")
            }.tag(Tab.verify)
            EvaluateView()
                .tabItem {
                    Image(systemName: "gauge")
                    Text("Evaluate")
            }.tag(Tab.evaluate)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }.tag(Tab.settings)
        }
        .accentColor(Color.lightTeal)
        .navigationBarBackButtonHidden(true)
    }
}

struct TabBarEvents {
    static let change = Notification.Name("ChangeTabNotification")
}

enum Tab: Hashable {
    case verify
    case evaluate
    case settings
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
