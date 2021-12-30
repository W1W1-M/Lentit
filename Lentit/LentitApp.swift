//
//  LentitApp.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

@main
struct LentitApp: App {
    @StateObject var lentItemsListVM: LentItemListVM = LentItemListVM()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(lentItemsListVM)
        }
    }
}
