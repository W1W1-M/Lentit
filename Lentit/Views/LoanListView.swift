//
//  LoanListView.swift
//  Lentit
//
//  Created by William Mead on 25/03/2022.
//

import SwiftUI
// MARK: -
struct LoanListStatusView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        HStack {
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
            Spacer()
            Menu {
                ForEach(StatusModel.loanStatusCases) { Status in
                    Button {
                        appVM.activeLoanStatus = Status
                    } label: {
                        StatusNameView(status: Status)
                        Image(systemName: Status.symbolName)
                    }
                }
            } label: {
                switch appVM.activeLoanStatus {
                case .all:
                    Text("all")
                        .fontWeight(.bold)
                        .fixedSize()
                case .new:
                    Text("new")
                        .fontWeight(.bold)
                        .fixedSize()
                case .upcoming:
                    Text("upcoming")
                        .fontWeight(.bold)
                        .fixedSize()
                case .current:
                    Text("ongoing")
                        .fontWeight(.bold)
                        .fixedSize()
                case .finished:
                    Text("finished")
                        .fontWeight(.bold)
                        .fixedSize()
                default:
                    Text("unknown")
                }
                ActiveLoanStatusIconView()
            }
        }.font(.title3)
        .textCase(.lowercase)
        .padding(.bottom)
    }
}
// MARK: -
struct LoanListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanListVM: LoanListVM
    var body: some View {
        List {
            Section {
                ForEach(appVM.loanVMs) { LoanVM in
                    LoanListItemView(loanVM: LoanVM)
                }
            } header: {
                LoanListStatusView(loanListVM: appVM.loanListVM)
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
                    Text("\(String(loanVM.loanItemName.prefix(2)))")
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                HStack {
                    Text("\(loanVM.loanItemName)").font(.headline)
                }
                Spacer()
                HStack {
                    switch appVM.activeLoanSort {
                    case LoanModel.SortingOrder.byItemName:
                        Text("\(loanVM.loanBorrowerName)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    case LoanModel.SortingOrder.byBorrowerName:
                        Text("\(loanVM.loanBorrowerName)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    case LoanModel.SortingOrder.byLoanDate:
                        Text("\(loanVM.loanDateText)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    default:
                        Text("\(loanVM.loanBorrowerName)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }.padding(2)
        }.onAppear(perform: {
            if(loanVM.status == StatusModel.new) {
                print("Programmatic navigation to new loan \(loanVM.id) ...")
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
                ForEach(LoanModel.SortingOrder.allCases) { SortingOrder in
                    Button {
                        appVM.activeLoanSort = SortingOrder
                    } label: {
                        HStack {
                            switch SortingOrder {
                            case LoanModel.SortingOrder.byItemName:
                                Text("by Item")
                            case LoanModel.SortingOrder.byBorrowerName:
                                Text("by Borrower")
                            case LoanModel.SortingOrder.byLoanDate:
                                Text("by Date")
                            default:
                                Text("")
                            }
                            if(appVM.activeLoanSort == SortingOrder) {
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
        LoanListStatusView(loanListVM: LoanListVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        LoanListView(loanListVM: LoanListVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        LoanListItemView(loanVM: LoanVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        LoanListBottomToolbarView().previewLayout(.sizeThatFits)
    }
}

