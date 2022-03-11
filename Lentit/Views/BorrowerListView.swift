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
    @Binding var sheetPresented: Bool
    var body: some View {
        NavigationView {
            List {
                if(borrowerListVM.newBorrowerPresented) {
                    Section(header: Text("🆕 New borrower")) {
                        TextField("Name", text: $borrowerListVM.newBorrowerName)
                    }
                    Section {
                        Button {
                            appVM.createBorrower(
                                id: borrowerListVM.newBorrowerId,
                                named: borrowerListVM.newBorrowerName
                            )
                            loanVM.setLoanBorrower(to: appVM.getBorrower(with: borrowerListVM.newBorrowerId))
                            borrowerListVM.hideNewBorrower()
                            sheetPresented = false
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
                Section(header: Text("\(borrowerListVM.borrowersCountText) borrowers")) {
                    ForEach(appVM.borrowerVMs) { BorrowerVM in
                        Button {
                            loanVM.setLoanBorrower(to: BorrowerVM)
                            sheetPresented = false
                        } label: {
                            HStack {
                                Text("\(BorrowerVM.nameText)")
                                Spacer()
                                if(loanVM.borrowerVM.id == BorrowerVM.id) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("Borrowers")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        borrowerListVM.hideNewBorrower()
                        sheetPresented = false
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
        }
    }
}

struct BorrowersListView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowerListView(
            borrowerListVM: BorrowerListVM(),
            loanVM: LoanVM(),
            sheetPresented: .constant(true)
        ).environmentObject(AppVM())
    }
}
