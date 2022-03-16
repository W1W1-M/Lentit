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
                    Spacer()
                    CreateLoanHintView()
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
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
        })
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
                        switch LoanStatusModel {
                        case LoanStatus.new:
                            Text("new")
                        case LoanStatus.upcoming:
                            Text("upcoming")
                        case LoanStatus.current:
                            Text("ongoing")
                        case LoanStatus.finished:
                            Text("finished")
                        default:
                            Text("unknown")
                        }
                        Image(systemName: LoanStatusModel.symbolName)
                    }
                }
            } label: {
                switch appVM.activeStatus {
                case LoanStatus.new:
                    Image(systemName: appVM.activeStatus.symbolName)
                        .foregroundColor(Color.blue)
                        .imageScale(.large)
                    Text("new").fontWeight(.bold)
                case LoanStatus.upcoming:
                    Image(systemName: appVM.activeStatus.symbolName)
                        .foregroundColor(Color.orange)
                        .imageScale(.large)
                    Text("upcoming").fontWeight(.bold)
                case LoanStatus.current:
                    Image(systemName: appVM.activeStatus.symbolName)
                        .foregroundColor(Color.green)
                        .imageScale(.large)
                    Text("ongoing").fontWeight(.bold)
                case LoanStatus.finished:
                    Image(systemName: appVM.activeStatus.symbolName)
                        .foregroundColor(Color.red)
                        .imageScale(.large)
                    Text("finished").fontWeight(.bold)
                default:
                    Image(systemName: appVM.activeStatus.symbolName)
                        .foregroundColor(Color.black)
                        .imageScale(.large)
                    Text("unknown")
                }
            }
            Spacer()
            switch loanListVM.loansCount {
            case 0:
                Text("")
            case 1:
                Text("\(loanListVM.loansCount) loan")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            default:
                Text("\(loanListVM.loansCount) loans")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
        }.font(.title3)
        .textCase(.lowercase)
        .padding(.horizontal, 30)
    }
}
// MARK: -
struct LoanListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        List {
            ForEach(appVM.loanVMs) { LoanVM in
                LoanListItemView(
                    loanVM: LoanVM
                )
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
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                    Text("\(String(loanVM.itemVM.nameText.prefix(2)))")
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                HStack {
                    Text("\(loanVM.itemVM.nameText)").font(.headline)
                }
                Spacer()
                HStack {
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
                }
            }.padding(2)
        }.onAppear(perform: {
            // Programmatic navigation to newly added loan
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
                            switch LoanSortingOrderModel {
                            case LoanSortingOrders.byItemName:
                                Text("by Item")
                            case LoanSortingOrders.byBorrowerName:
                                Text("by Borrower")
                            case LoanSortingOrders.byLoanDate:
                                Text("by Date")
                            default:
                                Text("")
                            }
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
        LoanListItemView(loanVM: LoanVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        NewLoanButtonView().previewLayout(.sizeThatFits)
        //
    }
}
