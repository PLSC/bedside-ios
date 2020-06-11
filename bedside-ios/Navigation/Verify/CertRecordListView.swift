    //
//  ProcedureListView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
    
@available(iOS 13.0, macOS 10.15, *)
struct RefreshableKeyTypes {
    
    struct PrefData: Equatable {
        let bounds: CGRect
    }

    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []

        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }

        typealias Value = [PrefData]
    }
}
    
@available(iOS 13.0, macOS 10.15, *)
class RefreshData: ObservableObject {
    @Published var isDone: Bool = true
    @Published var showText: String
    @Published var showRefreshView: Bool {
        didSet {
            self.showText = "Loading"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if self.showRefreshView {
                    self.showRefreshView = false
                    self.showDone = true
                    self.showText = "Done"
                }
            }
        }
    }
    @Published var pullStatus: CGFloat
    @Published var showDone: Bool {
        didSet {
            if self.showDone && self.isDone {
                self.showDone = false
                self.showText = "Pull to refresh"
            }
        }
    }
    
    init() {
        self.showText = "Pull to refresh"
        self.showRefreshView = false
        self.pullStatus = 0
        self.showDone = false
    }
}
    
struct RefreshView: View {
    @ObservedObject var data: RefreshData
    
    var body: some View {
        HStack() {

//                if self.data.showDone {
//                    Image(systemName: "checkmark.circle")
//                        .foregroundColor(Color.lightTeal)
//                        .imageScale(.large)
//                } else if (!data.showRefreshView) {
//                    Spinner(percentage: self.$data.pullStatus)
//                } else {
//                    ActivityIndicator(isAnimating: .constant(true), style: .large)
//                }
//                Text(self.data.showText).font(.caption)
            EmptyView()
            
        }
    }
}
    
struct Spinner: View {
    @Binding var percentage: CGFloat
    
    var body: some View {
        GeometryReader{ geometry in
            ForEach(1...10, id: \.self) { i in
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(1)
                    .frame(width: 2.5, height: 8)
                    .opacity(self.percentage * 10 >= CGFloat(i) ? Double(i)/10.0 : 0)
                    .offset(x: 0, y: -8)
                    .rotationEffect(.degrees(Double(36 * i)), anchor: .bottom)
            }.offset(x: 20, y: 12)
        }.frame(width: 40, height: 40)
    }
}
    
struct PullToRefreshView: View {
    @ObservedObject var data: RefreshData
    var body: some View {
        GeometryReader{ geometry in
            RefreshView(data: self.data)
                .opacity(Double((geometry.frame(in: CoordinateSpace.global).origin.y - 106) / 80)).preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(bounds: geometry.frame(in: CoordinateSpace.global))])
                
        }
    }
}
    
struct CertRecordListView: View {
    @EnvironmentObject var userLoginState : UserLoginState
    
    func refreshCertRecords() {
        userLoginState.fetchCurrentUserCertRecords()
    }
    
    var body: some View {
        let certifiedRecords = userLoginState.certRecordViewModel.certifiedRecords
        
        let notCertified = userLoginState.certRecordViewModel.notCertified
    
        return List {
            if !certifiedRecords.isEmpty {
                Section(header: CertifiedHeaderView()) {
                    ForEach(certifiedRecords) { certRecord in
                        NavigationLink(destination: CertRecordDetailView(certRecord: certRecord)) {
                            CertRecordRowView(certificationRecord: certRecord)
                        }
                    }
                }
            }
            
            if !notCertified.isEmpty {
                Section(header:InProgressHeaderView()) {
                    ForEach(notCertified) {
                        certRecord in
                        NavigationLink(destination: CertRecordDetailView(certRecord: certRecord)) {
                            CertRecordRowView(certificationRecord: certRecord)
                        }
                    }
                }
            }
        }.onAppear {
            UITableViewHeaderFooterView.appearance().tintColor = UIColor.clear
            self.refreshCertRecords()
        }
    }
}
    
struct InProgressHeaderView: View {
    var body: some View {
        return VStack(alignment:.leading) {
            Text("Procedures in progress".uppercased())
            .font(.caption)
            .padding(.horizontal)
        }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
    
struct CertifiedHeaderView: View {
    var body: some View {
        VStack(alignment:.leading) {
            Text("Dr. Lenox has been deemed competent to perform the following procedures under \("Indirect Supervision".uppercased())")
                .font(.caption)
        }
    }
}
    
