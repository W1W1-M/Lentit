//
//  BorrowerListView.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import SwiftUI

struct BorrowerListView: View {
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
                            BorrowerListItemView(
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
struct BorrowerListItemView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Button {
            loanVM.setLoanBorrower(to: borrowerVM)
            appVM.sheetPresented = false
        } label: {
            HStack {
                Text("\(borrowerVM.nameText)")
                Spacer()
                if(loanVM.borrowerVM.id == borrowerVM.id) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
// MARK: - Previews
struct BorrowersListView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowerListView(
            borrowerListVM: BorrowerListVM(),
            loanVM: LoanVM()
        ).environmentObject(AppVM())
    }
}


