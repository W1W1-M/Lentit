//
//  LentItemsListView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct LentItemsListView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    var body: some View {
        Form {
            Section(header: LentItemsListHeaderView()) {
                List {
                    ForEach(lentItemsListVM.lentItemVMs) { LentItemVM in
                        LentListItemView(
                            lentItemVM: LentItemVM
                        )
                    }
                }
            }
        }.navigationTitle("Lentit")
        .navigationViewStyle(DefaultNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    lentItemsListVM.addLentItem()
                } label: {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus.circle")
                    }
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                LentItemsListBottomToolbarView()
            }
        }
    }
}
// MARK: -
struct LentItemsListHeaderView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    var body: some View {
        HStack {
            if(lentItemsListVM.lentItemVMs.isEmpty) {
                EmptyView()
            } else {
                Text("\(lentItemsListVM.lentItemsCountText)")
            }
        }
    }
}
// MARK: -
struct LentListItemView: View {
    @ObservedObject var lentItemVM: LentItemVM
    @State var navigationLinkIsActive: Bool = false
    let today: Date = Date()
    var body: some View {
        NavigationLink(
            destination: LentItemDetailView(
                lentItemVM: lentItemVM,
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            if(today > lentItemVM.lendExpiry) {
                HStack {
                    Text(" \(lentItemVM.nameText)").foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "calendar.badge.exclamationmark").foregroundColor(Color.red)
                    Spacer()
                    Text("\(lentItemVM.lendDateText)").foregroundColor(.accentColor)
                }
            } else {
                HStack {
                    Text(" \(lentItemVM.nameText)").foregroundColor(.primary)
                    Spacer()
                    Text("\(lentItemVM.lendDateText)").foregroundColor(.accentColor)
                }
            }
        }
        .onAppear(perform: {
            // Navigation to newly added item
            if(lentItemVM.justAdded) {
                navigationLinkIsActive = true
            }
        })
    }
}
// MARK: -
struct LentItemsListBottomToolbarView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    var body: some View {
        Group {
            Menu {
                CategoriesListMenuItems()
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Category")
                }
            }
            Menu {
                Button {
                    lentItemsListVM.activeSort = SortingOrders.byLendDate
                } label: {
                    HStack {
                        Text("by lend date")
                        if(lentItemsListVM.activeSort == SortingOrders.byLendDate) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button {
                    lentItemsListVM.activeSort = SortingOrders.byItemName
                } label: {
                    HStack {
                        Text("by item name")
                        if(lentItemsListVM.activeSort == SortingOrders.byItemName) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Sort")
                    Image(systemName: "arrow.up.arrow.down.circle")
                }
            }
        }
    }
}
// MARK: - Previews
struct LentItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        //
        NavigationView {
            LentItemsListView()
        }.environmentObject(LentItemListVM())
        //
        LentListItemView(
            lentItemVM: LentItemVM()
        ).previewLayout(.sizeThatFits)
    }
}
