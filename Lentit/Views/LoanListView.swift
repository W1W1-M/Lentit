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
            Menu {
                ForEach(LoanModel.Status.allCases) { Status in
                    Button {
                        appVM.activeLoanStatus = Status
                    } label: {
                        switch Status {
                        case .all:
                            Text("all")
                        case .new:
                            Text("new")
                        case .upcoming:
                            Text("upcoming")
                        case .current:
                            Text("ongoing")
                        case .finished:
                            Text("finished")
                        default:
                            Text("unknown")
                        }
                        Image(systemName: Status.symbolName)
                    }
                }
            } label: {
                switch appVM.activeLoanStatus {
                case .all:
                    Image(systemName: appVM.activeLoanStatus.symbolName).foregroundColor(Color.blue)
                    Text("all").fontWeight(.bold)
                case .new:
                    Image(systemName: appVM.activeLoanStatus.symbolName).foregroundColor(Color.purple)
                    Text("new").fontWeight(.bold)
                case .upcoming:
                    Image(systemName: appVM.activeLoanStatus.symbolName).foregroundColor(Color.orange)
                    Text("upcoming").fontWeight(.bold)
                case .current:
                    Image(systemName: appVM.activeLoanStatus.symbolName).foregroundColor(Color.green)
                    Text("ongoing").fontWeight(.bold)
                case .finished:
                    Image(systemName: appVM.activeLoanStatus.symbolName).foregroundColor(Color.red)
                    Text("finished").fontWeight(.bold)
                default:
                    Text("unknown")
                }
            }.imageScale(.large)
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
                LoanListItemView(loanVM: LoanVM)
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
                    switch appVM.activeLoanSort {
                    case LoanModel.SortingOrder.byItemName:
                        Text("\(loanVM.borrowerVM.nameText)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    case LoanModel.SortingOrder.byBorrowerName:
                        Text("\(loanVM.borrowerVM.nameText)")
                            .italic()
                            .foregroundColor(Color("AccentColor"))
                    case LoanModel.SortingOrder.byLoanDate:
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
            if(loanVM.status == LoanModel.Status.new) {
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
            appVM.createEmptyLoan()
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
        NewLoanButtonView().previewLayout(.sizeThatFits)
        //
        LoanListBottomToolbarView().previewLayout(.sizeThatFits)
    }
}

