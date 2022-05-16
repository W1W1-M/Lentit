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
                                contactVM: ContactVM,
                                borrowerVM: borrowerVM
                            )
                        }
                    } header: {
                        Text("\(contactsVM.contactsVMs.count) contacts")
                    }
                }.listStyle(.insetGrouped)
            }.navigationTitle(Text("Contacts"))
            .toolbar {
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
}
// MARK: -
struct ContactsListEntryView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var contactVM: ContactVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Button {
            borrowerVM.updateVM(from: contactVM)
            appVM.sheetPresented = false
        } label: {
            HStack {
                Text("\(contactVM.name)")
                Spacer()
                if borrowerVM.contactId == contactVM.contact.identifier {
                    Image(systemName: "checkmark")
                } else {
                    Image(systemName: "xmark")
                }
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
