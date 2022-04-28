//
//  BorrowerListView.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import SwiftUI
// MARK: - Views
struct BorrowerListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerListVM: BorrowerListVM
    var body: some View {
        List {
            Section {
                ForEach(appVM.borrowerVMs) { BorrowerVM in
                    BorrowerListItemView(borrowerVM: BorrowerVM)
                }
            } header: {
                HStack {
                    switch borrowerListVM.borrowersCount {
                    case 0:
                        EmptyView()
                    case 1:
                        Text("\(borrowerListVM.borrowersCount) borrower")
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    default:
                        Text("\(borrowerListVM.borrowersCount) borrowers")
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }.font(.title3)
                .textCase(.lowercase)
                .padding(.bottom)
            }
        }.listStyle(.plain)
    }
}
// MARK: -
struct BorrowerListItemView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: BorrowerDetailView(
                borrowerVM: appVM.getBorrowerVM(for: borrowerVM.id),
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                    Text("\(String(borrowerVM.name.prefix(2)))")
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                Text("\(borrowerVM.name)").foregroundColor(.primary)
                Spacer()
                Text("\(borrowerVM.loanCount) loans").foregroundColor(.secondary)
            }
        }
    }
}
// MARK: -
struct BorrowerListSheetView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerListVM: BorrowerListVM
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                List {
                    if(borrowerListVM.newBorrowerPresented) {
                        Section(header: Text("🆕 New borrower")) {
                            TextField("Name", text: $borrowerListVM.newBorrowerName)
                        }
                        Section {
                            Button {
                                borrowerListVM.newBorrowerId = appVM.createBorrower(named: borrowerListVM.newBorrowerName)
                                loanVM.setLoanBorrower(to: appVM.getBorrower(with: borrowerListVM.newBorrowerId))
                                borrowerListVM.hideNewBorrower()
                                appVM.sheetPresented = false
                            } label: {
                                HStack {
                                    Spacer()
                                    Image(systemName: "person.badge.plus").imageScale(.large)
                                    Text("Save new borrower")
                                    Spacer()
                                }
                            }.font(.headline)
                            .foregroundColor(.white)
                        }.listRowBackground(Color("InvertedAccentColor"))
                    }
                    Section(header: Text("\(borrowerListVM.borrowersCount) borrowers")) {
                        ForEach(appVM.borrowerVMs) { BorrowerVM in
                            BorrowerListItemSheetView(
                                loanVM: loanVM,
                                borrowerVM: BorrowerVM
                            )
                        }
                    }
                }.navigationTitle("Borrowers")
                .listStyle(.insetGrouped)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            borrowerListVM.hideNewBorrower()
                            appVM.sheetPresented = false
                        } label: {
                            Text("Close")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            borrowerListVM.showNewBorrower()
                        } label: {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                }
                .onAppear(perform: {
                    // Background color fix
                    UITableView.appearance().backgroundColor = .clear
                })
            }
        }
    }
}
// MARK: -
struct BorrowerListItemSheetView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Button {
            loanVM.setLoanBorrower(to: borrowerVM.model)
            appVM.sheetPresented = false
        } label: {
            HStack {
                Text("\(borrowerVM.name)")
                Spacer()
                if(loanVM.loanBorrower.id == borrowerVM.id) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
// MARK: - Previews
struct BorrowersListView_Previews: PreviewProvider {
    static var previews: some View {
        //
        BorrowerListView(borrowerListVM: BorrowerListVM()).environmentObject(AppVM())
        //
        BorrowerListSheetView(
            borrowerListVM: BorrowerListVM(),
            loanVM: LoanVM()
        ).environmentObject(AppVM())
    }
}
