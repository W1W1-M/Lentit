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
                    Section(header: Text("Ne borrower")) {
                        TextField("Name", text: $borrowerListVM.newBorrowerName)
                        Spacer()
                        Button {
                            appVM.createBorrower(named: borrowerListVM.newBorrowerName)
                            borrowerListVM.hideNewBorrower()
                        } label: {
                            HStack {
                                Text("Save")
                            }
                        }
                    }
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