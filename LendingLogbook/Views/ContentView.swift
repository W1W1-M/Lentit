//
//  ContentView.swift
//  LendingLogbook
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
                SidebarMenu()
                Lends()
                LentItemDetail()
            }
        case .compact:
            NavigationView {
                Lends()
            }
        case .none:
            NavigationView {
                Lends()
            }
        case .some(_):
            NavigationView {
                Lends()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewInterfaceOrientation(.landscapeLeft)
    }
}
