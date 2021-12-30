//
//  ContentView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        switch sizeClass {
        case .regular:
            NavigationView {
                SidebarMenuView()
                LentItemsListView()
                LentItemDetailView(lentItemVM: LentItemVM())
            }
        case .compact:
            NavigationView {
                LentItemsListView()
            }
        case .none:
            NavigationView {
                LentItemsListView()
            }
        case .some(_):
            NavigationView {
                LentItemsListView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView().previewInterfaceOrientation(.landscapeLeft)
                .environmentObject(LentItemListVM())
        } else {
            ContentView()
                .environmentObject(LentItemListVM())
        }
    }
}
