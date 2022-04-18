//
//  ContactsVM.swift
//  Lentit
//
//  Created by William Mead on 16/04/2022.
//

import Foundation
import Contacts
/// Contacts view model
final class ContactsVM: ObservableObject, Identifiable {
    // MARK: - Properties
    private(set) var borrower: BorrowerModel
    private(set) var id: UUID
    internal var contactsStore: CNContactStore
    internal var contactsAccess: CNAuthorizationStatus
    @Published var borrowerContactLink: Bool
    // MARK: - Init & deinit
    init(
        borrower: BorrowerModel,
        contactsStore: CNContactStore,
        contactsAccess: CNAuthorizationStatus
    ) {
        print("ContactsVM init ...")
        self.borrower = borrower
        self.id = UUID()
        self.contactsStore = contactsStore
        self.contactsAccess = contactsAccess
        self.borrowerContactLink = true
        //
        
    }
    deinit {
        print("... deinit ContactsVM")
    }
    // MARK: - Methods
    func requestContactsAccess() {
        print("requestContactsAccess ...")
        contactsStore.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.contactsAccess = .authorized
                print("Contacts access authorized")
            }
            if let error = error {
                print(error)
                print("Contacts access not authorized")
                return
            }
        }
    }
    func checkContactsAccess() {
        print("checkContactsAccess ...")
        self.contactsAccess = CNContactStore.authorizationStatus(for: .contacts)
        if(contactsAccess != .authorized) {
            requestContactsAccess()
        }
    }
}
