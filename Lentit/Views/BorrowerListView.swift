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
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
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
                            BorrowerListItemView(
                                loanVM: loanVM,
                                borrowerVM: BorrowerVM,
                                sheetPresented: $sheetPresented
                            )
                        }
                    }
                }.navigationTitle("Borrowers")
                .listStyle(.insetGrouped)
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
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var borrowerVM: BorrowerVM
    @Binding var sheetPresented: Bool
    var body: some View {
        Button {
            loanVM.setLoanBorrower(to: borrowerVM)
            sheetPresented = false
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
            loanVM: LoanVM(),
            sheetPresented: .constant(true)
        ).environmentObject(AppVM())
    }
}


