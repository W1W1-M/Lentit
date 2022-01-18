//
//  ContentView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        switch sizeClass {
        case .regular:
            NavigationView {
                SidebarMenuView()
                LoansListView()
                EmptyView()
            }
        case .compact:
            NavigationView {
                LoansListView()
            }
        case .none:
            NavigationView {
                LoansListView()
            }
        case .some(_):
            NavigationView {
                LoansListView()
            }
        }
    }
}
// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView().previewInterfaceOrientation(.portrait)
                .environmentObject(LentItemListVM())
        } else {
            ContentView()
                .environmentObject(LentItemListVM())
        }
    }
}
