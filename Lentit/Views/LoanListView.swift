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
                ForEach(LoanModel.Status.allCases) { Status in
                    Button {
                        appVM.activeLoanStatus = Status
                    } label: {
                        LoanStatusNameView(loanStatus: Status)
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
                ForEach(appVM.loanListEntryVMs) { LoanListEntryVM in
                    LoanListItemView(loanListEntryVM: LoanListEntryVM)
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
    @ObservedObject var loanListEntryVM: LoanListEntryVM
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: LoanDetailView(
                loanVM: appVM.getLoanVM(for: loanListEntryVM.id),
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                    Text("\(String(loanListEntryVM.itemName.prefix(2)))")
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                HStack {
                    Text("\(loanListEntryVM.itemName)").font(.headline)
                }
                Spacer()
                HStack {
                    switch appVM.activeLoanSort {
                    case LoanModel.SortingOrder.byItemName:
                        Text("\(loanListEntryVM.borrowerName)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    case LoanModel.SortingOrder.byBorrowerName:
                        Text("\(loanListEntryVM.borrowerName)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    case LoanModel.SortingOrder.byLoanDate:
                        Text("\(loanListEntryVM.loanDateText)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    default:
                        Text("\(loanListEntryVM.borrowerName)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    }
                }
            }.padding(2)
        }.onAppear(perform: {
            if(loanListEntryVM.loanStatus == LoanModel.Status.new) {
                print("Programmatic navigation to new loan ...")
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
        LoanListItemView(loanListEntryVM: LoanListEntryVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        LoanListBottomToolbarView().previewLayout(.sizeThatFits)
    }
}

