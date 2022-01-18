//
//  LoanListView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct LoanListView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    var body: some View {
        Form {
            Section(header: LoanListHeaderView()) {
                List {
                    ForEach(lentItemsListVM.lentItemVMs) { LentItemVM in
                        LoanListItemView(
                            lentItemVM: LentItemVM
                        )
                    }
                }
            }
        }.navigationTitle("📒 Lentit")
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
                LoanListBottomToolbarView()
            }
        }
    }
}
// MARK: -
struct LoanListHeaderView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    var body: some View {
        HStack {
            if(lentItemsListVM.lentItemVMs.isEmpty) {
                EmptyView()
            } else {
                HStack {
                    Text("\(lentItemsListVM.lentItemsCountText) loans")
                    Spacer()
                    Text("\(lentItemsListVM.activeCategory.name)")
                }
            }
        }
    }
}
// MARK: -
struct LoanListItemView: View {
    @ObservedObject var lentItemVM: LentItemVM
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: LoanDetailView(
                lentItemVM: lentItemVM,
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                Text(" \(lentItemVM.nameText)").foregroundColor(.primary)
                Spacer()
                Text("\(lentItemVM.borrowerNameText)").foregroundColor(.accentColor)
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
struct LoanListBottomToolbarView: View {
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
                    lentItemsListVM.activeSort = SortingOrders.byLendExpiry
                } label: {
                    HStack {
                        Text("by expiry date")
                        if(lentItemsListVM.activeSort == SortingOrders.byLendExpiry) {
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
struct LoanListView_Previews: PreviewProvider {
    static var previews: some View {
        //
        NavigationView {
            LoanListView()
        }.environmentObject(LentItemListVM())
        //
        LoanListItemView(
            lentItemVM: LentItemVM()
        ).previewLayout(.sizeThatFits)
    }
}
