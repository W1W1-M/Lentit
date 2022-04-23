//
//  ContactsListView.swift
//  Lentit
//
//  Created by William Mead on 18/04/2022.
//

import SwiftUI
import Contacts
// MARK: - Views
struct ContactsListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var contactsVM: ContactsVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                List {
                    Section {
                        ForEach(contactsVM.contactsVMs) { ContactVM in
                            ContactsListEntryView(
                                contactListEntryVM: ContactVM,
                                borrowerVM: borrowerVM
                            )
                        }
                    } header: {
                        Text("\(contactsVM.contactsVMs.count) contacts")
                    }
                }.listStyle(.insetGrouped)
            }
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    appVM.sheetPresented = false
                } label: {
                    Text("Close")
                }
            }
        }
    }
}
// MARK: -
struct ContactsListEntryView: View {
    @ObservedObject var contactListEntryVM: ContactListEntryVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Button {
            borrowerVM.updateName(to: contactListEntryVM.name)
        } label: {
            HStack {
                Text("\(contactListEntryVM.name)")
                Spacer()
                Image(systemName: "xmark")
            }
        }
    }
}
// MARK: - Previews
struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView(
            contactsVM: ContactsVM(contactsStore: CNContactStore(), contactsAccess: .authorized),
            borrowerVM: BorrowerVM()
        )
    }
}
