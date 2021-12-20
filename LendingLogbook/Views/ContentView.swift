//
//  ContentView.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @ObservedObject var lentItemsStore: LentItemStore = LentItemStore(itemData: LentItemStore.sampleData)
    var body: some View {
        switch sizeClass {
        case .regular:
            NavigationView {
                SidebarMenuView()
                LentItemsListView(
                    lentItemsStore: lentItemsStore
                )
                LentItemDetailView(
                    lentItem: LentItemStore.sampleData[0]
                )
            }
        case .compact:
            NavigationView {
                LentItemsListView(
                    lentItemsStore: lentItemsStore
                )
            }
        case .none:
            NavigationView {
                LentItemsListView(
                    lentItemsStore: lentItemsStore
                )
            }
        case .some(_):
            NavigationView {
                LentItemsListView(
                    lentItemsStore: lentItemsStore
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView().previewInterfaceOrientation(.landscapeLeft)
        } else {
            ContentView()
        }
    }
}
