//
//  BorrowerListView.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import SwiftUI
//
struct BorrowerListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerListVM: BorrowerListVM
    var body: some View {
        List {
            Section {
                ForEach(appVM.borrowerListEntryVMs) { BorrowerListEntryVM in
                    BorrowerListItemView(borrowerListEntryVM: BorrowerListEntryVM)
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
//
struct BorrowerListItemView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerListEntryVM: BorrowerListEntryVM
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: BorrowerDetailView(
                borrowerVM: appVM.getBorrowerVM(for: borrowerListEntryVM.id),
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                    Text("\(String(borrowerListEntryVM.name.prefix(2)))")
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                Text("\(borrowerListEntryVM.name)").foregroundColor(.primary)
                Spacer()
                Text("\(borrowerListEntryVM.loanCount) loans").foregroundColor(.secondary)
            }
        }
    }
}
//
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
                                // loanVM.setLoanBorrower(to: try appVM.dataStore.readStoredBorrower(borrowerListVM.newBorrowerId))
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
                        ForEach(appVM.borrowerListEntryVMs) { BorrowerListEntryVM in
                            BorrowerListItemSheetView(
                                loanVM: loanVM,
                                borrowerListEntryVM: BorrowerListEntryVM
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
    @ObservedObject var borrowerListEntryVM: BorrowerListEntryVM
    var body: some View {
        Button {
            loanVM.setLoanBorrower(to: borrowerListEntryVM.borrower)
            appVM.sheetPresented = false
        } label: {
            HStack {
                Text("\(borrowerListEntryVM.name)")
                Spacer()
                if(loanVM.loanBorrower.id == borrowerListEntryVM.id) {
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
