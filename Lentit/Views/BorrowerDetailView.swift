//
//  BorrowerDetailView.swift
//  Lentit
//
//  Created by William Mead on 25/03/2022.
//

import SwiftUI
// MARK: - Views
struct BorrowerDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    BorrowerDetailSectionView(borrowerVM: borrowerVM).disabled(borrowerVM.editDisabled)
                    BorrowerHistorySectionView(borrowerVM: borrowerVM)
                    if(borrowerVM.status == StatusModel.new) {
                        SaveButtonView(
                            editDisabled: $borrowerVM.editDisabled,
                            navigationLinkIsActive: $navigationLinkIsActive,
                            element: .Borrowers,
                            viewModel: borrowerVM
                        )
                    } else {
                        DeleteButtonView(element: .Borrowers)
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
                            navigationLinkIsActive = false // Navigate back to borrower list
                            appVM.deleteBorrower(for: borrowerVM.id)
                        }
                    )
                )
            default:
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
            }
        }
        .sheet(isPresented: $appVM.sheetPresented) {
            ContactsListView(contactsVM: ContactsVM(
                contactsStore: appVM.contactsStore,
                contactsAccess: appVM.contactsAccess
            ), borrowerVM: borrowerVM
            )
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
    var body: some View {
        Section {
            Toggle(isOn: $borrowerVM.contactLink) {
                Text("Apple iOS Contacts link")
            }
            if borrowerVM.contactLink {
                BorrowerDetailSectionContactView(
                    borrowerVM: borrowerVM,
                    contactsVM: ContactsVM(
                        contactsStore: appVM.contactsStore,
                        contactsAccess: appVM.contactsAccess
                    )
                )
            } else {
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
            appVM.activeSheet = .contactsList
            appVM.sheetPresented = true
        } label: {
            HStack {
                Text("\(borrowerVM.name)")
                Image(systemName: "person")
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
                    Text("borrowed")
                    Spacer()
                    Text("\(borrowerVM.loanCount) time")
                }
            default:
                HStack {
                    Text("borrowed")
                    Spacer()
                    Text("\(borrowerVM.loanCount) times")
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
                navigationLinkIsActive: .constant(true)
            ).environmentObject(AppVM())
        }
    }
}
