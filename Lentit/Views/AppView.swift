//
//  AppView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct AppView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject var appVM: AppVM = AppVM()
    var body: some View {
        switch sizeClass {
        case .regular:
            NavigationView {
                SidebarMenuView()
                LoanListView(loanListVM: appVM.loanListVM)
                EmptyView()
            }.environmentObject(appVM)
        case .compact:
            NavigationView {
                LoanListView(loanListVM: appVM.loanListVM)
            }.environmentObject(appVM)
        case .none:
            NavigationView {
                LoanListView(loanListVM: appVM.loanListVM)
            }.environmentObject(appVM)
        case .some(_):
            NavigationView {
                LoanListView(loanListVM: appVM.loanListVM)
            }.environmentObject(appVM)
        }
    }
}
// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            AppView().previewInterfaceOrientation(.portrait)
                .environmentObject(AppVM())
        } else {
            AppView()
                .environmentObject(AppVM())
        }
    }
}
