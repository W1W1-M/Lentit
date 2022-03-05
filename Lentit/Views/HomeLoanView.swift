//
//  HomeLoanView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct HomeLoanView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                LoanListStatusView(loanListVM: appVM.loanListVM)
                if(appVM.loanListVM.loansCount == 0) {
                    EmptyLoanListView()
                    Spacer()
                } else {
                    LoanListView(loanListVM: appVM.loanListVM)
                }
                NewLoanButtonView()
            }
        }.navigationTitle("📒 Loans")
        .navigationViewStyle(DefaultNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
                } label: {
                    HStack {
                        Text("Settings")
                        Image(systemName: "gear")
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
struct LoanListStatusView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        HStack {
            Menu {
                ForEach(LoanStatus.status) { LoanStatusModel in
                    Button {
                        appVM.activeStatus = LoanStatusModel
                    } label: {
                        Text(LocalizedStringKey(LoanStatusModel.name))
                        Image(systemName: LoanStatusModel.symbolName)
                    }
                }
            } label: {
                Image(systemName: appVM.activeStatus.symbolName).imageScale(.large)
                Text(LocalizedStringKey(appVM.activeStatus.name)).fontWeight(.bold)
            }
            Spacer()
            if(loanListVM.loansCount > 0) {
                Text("\(loanListVM.loansCountText)").fontWeight(.bold)
            }
        }.font(.title3)
        .textCase(.lowercase)
        .padding(.horizontal, 40)
        .padding(.vertical)
    }
}
// MARK: -
struct EmptyLoanListView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        VStack {
            Text("No \(appVM.activeStatus.name) Loans (\(appVM.activeCategory.name))")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding()
            Image(systemName: "eyes")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding()
        }
    }
}
// MARK: -
struct LoanListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        List {
            Section() {
                ForEach(appVM.loanVMs) { LoanVM in
                    LoanListItemView(
                        loanVM: LoanVM
                    )
                }
            }
        }.listStyle(.plain)
    }
}
// MARK: -
struct LoanListItemView: View {
    @EnvironmentObject var appVM: AppVM
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
                Text("\(loanVM.itemVM.nameText)")
                Spacer()
                switch appVM.activeSort {
                case LoanSortingOrders.byItemName:
                    Text("\(loanVM.borrowerVM.nameText)")
                        .italic()
                        .foregroundColor(Color("AccentColor"))
                case LoanSortingOrders.byBorrowerName:
                    Text("\(loanVM.borrowerVM.nameText)")
                        .italic()
                        .foregroundColor(Color("AccentColor"))
                case LoanSortingOrders.byLoanDate:
                    Text("\(loanVM.loanDateText)")
                        .italic()
                        .foregroundColor(Color("AccentColor"))
                default:
                    Text("\(loanVM.borrowerVM.nameText)")
                        .italic()
                        .foregroundColor(Color("AccentColor"))
                }
//                Text("\(loanVM.borrowerVM.nameText)")
//                    .italic()
//                    .foregroundColor(Color("AccentColor"))
            }
        }.onAppear(perform: {
            // Navigation to newly added loan
            if(loanVM.status == LoanStatus.new) {
                navigationLinkIsActive = true
            }
        })
    }
}
// MARK: -
struct NewLoanButtonView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        Button {
            appVM.createLoan()
        } label: {
            HStack {
                Spacer()
                Text("New Loan").font(.headline)
                Image(systemName: "plus.circle").imageScale(.large)
                Spacer()
            }.font(.headline)
            .foregroundColor(.white)
            .padding()
        }.background(Color("InvertedAccentColor"))
        .clipShape(Capsule())
        .padding()
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
                ForEach(LoanSortingOrders.sortingOrders) { LoanSortingOrderModel in
                    Button {
                        appVM.activeSort = LoanSortingOrderModel
                    } label: {
                        HStack {
                            Text(LoanSortingOrderModel.name)
                            if(appVM.activeSort == LoanSortingOrderModel) {
                                Image(systemName: "checkmark")
                            }
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
            HomeLoanView()
        }.environmentObject(AppVM())
        //
        LoanListStatusView(loanListVM: LoanListVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        EmptyLoanListView()
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        LoanListItemView(loanVM: LoanVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        NewLoanButtonView().previewLayout(.sizeThatFits)
        //
    }
}
