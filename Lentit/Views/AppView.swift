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
                HomeView()
                SelectLoanHintView()
            }.environmentObject(appVM)
        case .compact:
            NavigationView {
                HomeView()
            }.environmentObject(appVM)
        case .none:
            NavigationView {
                HomeView()
            }.environmentObject(appVM)
        case .some(_):
            NavigationView {
                HomeView()
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
                .environment(\.locale, .init(identifier: "fr_FR"))
        } else {
            AppView()
                .environmentObject(AppVM())
        }
    }
}
