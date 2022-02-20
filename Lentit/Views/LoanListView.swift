//
//  LoanListView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct LoanListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        Form {
            Section(header: LoanListHeaderView(loanListVM: loanListVM)) {
                List {
                    ForEach(appVM.loanVMs) { LoanVM in
                        LoanListItemView(
                            loanVM: LoanVM
                        )
                    }
                }
            }
        }.navigationTitle("📒 Loans")
        .navigationViewStyle(DefaultNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    appVM.createLoan()
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
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        HStack {
            Menu {
                ForEach(LoanFilters.filters) { LoanFilterModel in
                    Button {
                        appVM.activeFilter = LoanFilterModel
                    } label: {
                        HStack {
                            Text(LoanFilterModel.name)
                            Image(systemName: LoanFilterModel.symbolName)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: appVM.activeFilter.symbolName).foregroundColor(.accentColor)
                    Text(appVM.activeFilter.name).fontWeight(.bold)
                }
            }
            Spacer()
            Text("\(loanListVM.loansCountText) loans").fontWeight(.bold)
        }.font(.title3)
        .textCase(.lowercase)
        .padding(.bottom, 10.0)
    }
}
// MARK: -
struct LoanListItemView: View {
    @ObservedObject var loanVM: LoanVM
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: LoanDetailView(
                loanVM: loanVM,
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                Text(" \(loanVM.itemVM.nameText)").foregroundColor(.primary)
                Spacer()
                Text("\(loanVM.borrowerVM.nameText)").foregroundColor(.accentColor)
            }
        }
        .onAppear(perform: {
            // Navigation to newly added item
            if(loanVM.justAdded) {
                navigationLinkIsActive = true
            }
        })
    }
}
// MARK: -
struct LoanListBottomToolbarView: View {
    @EnvironmentObject var appVM: AppVM
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
                    appVM.activeSort = LoanSortingOrders.byItemName
                } label: {
                    HStack {
                        Text("by item")
                        if(appVM.activeSort == LoanSortingOrders.byItemName) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button {
                    appVM.activeSort = LoanSortingOrders.byBorrowerName
                } label: {
                    HStack {
                        Text("by borrower")
                        if(appVM.activeSort == LoanSortingOrders.byBorrowerName) {
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
            LoanListView(loanListVM: LoanListVM())
        }.environmentObject(AppVM())
        //
        LoanListItemView(
            loanVM: LoanVM()
        ).previewLayout(.sizeThatFits)
    }
}
