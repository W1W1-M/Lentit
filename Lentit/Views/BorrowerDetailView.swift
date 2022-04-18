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
    @ObservedObject var borrowerDetailVM: BorrowerDetailVM
    @State var editDisabled: Bool = true
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    BorrowerDetailSectionView(
                        borrowerDetailVM: borrowerDetailVM,
                        contactsVM: appVM.getContactsVM(for: borrowerDetailVM.borrower),
                        editDisabled: $editDisabled
                    ).disabled(editDisabled)
                    BorrowerHistorySectionView(borrowerDetailVM: borrowerDetailVM)
                    if(borrowerDetailVM.status == StatusModel.new) {
                        SaveButtonView(
                            editDisabled: $editDisabled,
                            navigationLinkIsActive: $navigationLinkIsActive,
                            element: .Borrowers,
                            elementId: borrowerDetailVM.id
                        )
                    } else {
                        DeleteButtonView(element: .Borrowers)
                    }
                }
            }
        }.navigationTitle("\(borrowerDetailVM.name)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(borrowerDetailVM.status != StatusModel.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
        }
        .alert(isPresented: $appVM.alertPresented) {
            switch appVM.activeAlert {
            case .deleteBorrower:
                return Alert(
                    title: Text("Delete \(borrowerDetailVM.name)"),
                    message: Text("Are you sure you want to delete this borrower ?"),
                    primaryButton: .default(
                        Text("Cancel")
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            navigationLinkIsActive = false // Navigate back to borrower list
                            appVM.deleteBorrower(for: borrowerDetailVM.id)
                        }
                    )
                )
            default:
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
            }
        }
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
            // Unlock edit mode if item just added
            if(borrowerDetailVM.status == StatusModel.new) {
                editDisabled = false
            }
        })
    }
}
// MARK: -
struct BorrowerDetailSectionView: View {
    @ObservedObject var borrowerDetailVM: BorrowerDetailVM
    @ObservedObject var contactsVM: ContactsVM
    @Binding var editDisabled: Bool
    var body: some View {
        Section {
            if contactsVM.borrowerContactLink {
                Button {
                    contactsVM.checkContactsAccess()
                } label: {
                    HStack {
                        Text("some name")
                        Image(systemName: "person")
                    }
                }
            } else {
                Button {
                    contactsVM.checkContactsAccess()
                } label: {
                    HStack {
                        Text("Select contact")
                        Image(systemName: "person.plus")
                    }
                }
                TextField("Name", text: $borrowerDetailVM.name).foregroundColor(editDisabled ? .secondary : .primary)
            }
        } header: {
            Text("Borrower")
        }
    }
}
// MARK: -
struct BorrowerHistorySectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerDetailVM: BorrowerDetailVM
    var body: some View {
        Section {
            ForEach(borrowerDetailVM.loanIds.sorted(by: ==), id: \.self) { Id in
                BorrowerHistoryItemView(loanVM: appVM.getLoanVM(for: Id))
            }
        } header: {
            switch borrowerDetailVM.loanCount {
            case 0:
                EmptyView()
            case 1:
                HStack {
                    Text("borrowed")
                    Spacer()
                    Text("\(borrowerDetailVM.loanCount) time")
                }
            default:
                HStack {
                    Text("borrowed")
                    Spacer()
                    Text("\(borrowerDetailVM.loanCount) times")
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
                borrowerDetailVM: BorrowerDetailVM(),
                navigationLinkIsActive: .constant(true)
            ).environmentObject(AppVM())
        }
    }
}
