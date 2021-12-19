//
//  SidebarMenu.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct SidebarMenu: View {
    var body: some View {
        List() {
            HStack {
                Text("Lend")
                Spacer()
                Image(systemName: "square.and.arrow.up")
            }.font(.headline)
            HStack {
                Text("Borrow")
                Spacer()
                Image(systemName: "square.and.arrow.down")
            }.font(.headline)
        }.listStyle(SidebarListStyle())
        .navigationTitle("📒 Lending Logbook")
    }
}

struct SidebarMenu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SidebarMenu()
        }
    }
}
