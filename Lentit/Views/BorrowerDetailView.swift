//
//  BorrowerDetailView.swift
//  Lentit
//
//  Created by William Mead on 25/03/2022.
//

import SwiftUI
import Contacts
// MARK: - Views
struct BorrowerDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    @ObservedObject var contactsVM: ContactsVM
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    BorrowerDetailSectionView(
                        borrowerVM: borrowerVM,
                        contactsVM: contactsVM
                    ).disabled(borrowerVM.editDisabled)
                    BorrowerHistorySectionView(borrowerVM: borrowerVM)
                    if(borrowerVM.status == StatusModel.new) {
                        SaveButtonView(
                            element: .Borrowers,
                            viewModel: borrowerVM
                        )
                    } else {
                        if borrowerVM.contactLink {
                            Section {
                                CallMessageBorrowerButtonView(contactVM: contactsVM.getBorrowerContactVM(for: borrowerVM.model))
                            }
                        }
                        Section {
                            DeleteButtonView(element: .Borrowers)
                        }
                    }
                }
            }
        }.navigationTitle("\(borrowerVM.name)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(borrowerVM.status != StatusModel.new) {
                    EditButtonView(editDisabled: $borrowerVM.editDisabled)
                }
            }
        }
        .alert(isPresented: $appVM.alertPresented) {
            switch appVM.activeAlert {
            case .deleteBorrower:
                return Alert(
                    title: Text("Delete \(borrowerVM.name)"),
                    message: Text("Are you sure you want to delete this borrower ?"),
                    primaryButton: .default(
                        Text("Cancel")
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            borrowerVM.navigationLinkActive = false // Navigate back to borrower list
                            appVM.deleteBorrower(for: borrowerVM.id)
                        }
                    )
                )
            default:
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
            }
        }
        .sheet(isPresented: $appVM.sheetPresented) {
            ContactsListView(contactsVM: contactsVM, borrowerVM: borrowerVM)
        }
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
            // Unlock edit mode if item just added
            if(borrowerVM.status == StatusModel.new) {
                borrowerVM.editDisabled = false
            }
        })
    }
}
// MARK: -
struct BorrowerDetailSectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    @ObservedObject var contactsVM: ContactsVM
    var body: some View {
        Section {
            BorrowerDetailSectionContactView(
                borrowerVM: borrowerVM,
                contactsVM: contactsVM
            )
            if borrowerVM.contactLink == false {
                TextField("Name", text: $borrowerVM.name).foregroundColor(borrowerVM.editDisabled ? .secondary : .primary)
            }
        } header: {
            Text("Borrower")
        }
    }
}
// MARK: -
struct BorrowerDetailSectionContactView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    @ObservedObject var contactsVM: ContactsVM
    var body: some View {
        Button {
            borrowerVM.contactLink = true
            appVM.activeSheet = .contactsList
            appVM.sheetPresented = true
        } label: {
            Toggle(isOn: $borrowerVM.contactLink) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                    if borrowerVM.contactId != nil && borrowerVM.contactLink {
                        Text("\(borrowerVM.name)")
                    } else {
                        Text("Select iOS contact")
                    }
                }
            }
        }.onAppear(perform: {
            contactsVM.checkBorrowerContact(for: borrowerVM)
        })
    }
}
// MARK: -
struct BorrowerHistorySectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Section {
            ForEach(borrowerVM.loanIds.sorted(by: ==), id: \.self) { Id in
                BorrowerHistoryItemView(loanVM: appVM.getLoanVM(for: Id))
            }
        } header: {
            switch borrowerVM.loanCount {
            case 0:
                EmptyView()
            case 1:
                HStack {
                    Text("history")
                    Spacer()
                    Text("\(borrowerVM.loanCount) loan")
                }
            default:
                HStack {
                    Text("history")
                    Spacer()
                    Text("\(borrowerVM.loanCount) loans")
                }
            }
        }
    }
}
// MARK: -
struct BorrowerHistoryItemView: View {
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        HStack {
            Text("\(loanVM.loanItemName)")
            Spacer()
            Text("\(loanVM.loanDateText)")
        }
    }
}
// MARK: - Previews
struct BorrowerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BorrowerDetailView(
                borrowerVM: BorrowerVM(),
                contactsVM: ContactsVM(
                    contactsStore: CNContactStore(),
                    contactsAccess: .authorized
                )
            ).environmentObject(AppVM())
        }
    }
}
