//
//  ContactsVM.swift
//  Lentit
//
//  Created by William Mead on 16/04/2022.
//

import Foundation
import Contacts
/// Contacts view model
final class ContactsVM: ObservableObject {
// MARK: - Properties
    internal var contactsStore: CNContactStore
    internal var contactsAccess: CNAuthorizationStatus {
        didSet {
            print("Contacts access level: \(contactsAccess.rawValue)")
        }
    }
    internal var contacts: Array<CNContact>
    @Published var contactsVMs: Array<ContactVM>
// MARK: - Init & deinit
    init(
        contactsStore: CNContactStore,
        contactsAccess: CNAuthorizationStatus
    ) {
        print("ContactsVM init ...")
        self.contactsStore = contactsStore
        self.contactsAccess = contactsAccess
        self.contacts = []
        self.contactsVMs = []
        //
        checkContactsAccess()
        setContacts()
        setContactsVMs()
        sortContactsVMs()
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
    func getContacts() throws -> [CNContact] {
        print("getContacts ...")
        var contacts: Array<CNContact> = []
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactThumbnailImageDataKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try contactsStore.enumerateContacts(with: request) {
                (contact, stop) in
                contacts.append(contact)
            }
            return contacts
        } catch {
            print(error)
            throw error
        }
    }
    func setContacts() {
        print("setContacts ...")
        do {
            self.contacts = try getContacts()
            print(contacts)
        } catch {
            print("setContacts error")
        }
    }
    func setContactsVMs() {
        print("setContactsVMs ...")
        for contact in self.contacts {
            let contactVM = ContactVM()
            contactVM.setVM(contact: contact)
            contactsVMs.append(contactVM)
        }
    }
    func sortContactsVMs() {
        contactsVMs.sort()
    }
    func getBorrowerContact(for borrowerVM: BorrowerVM) -> CNContact? {
        print("getBorrowerContact ...")
        do {
            let contacts = try getContacts()
            return contacts.first(where: { $0.identifier == borrowerVM.contactId } )
        } catch {
            print("getBorrowerContact error")
            return nil
        }
    }
    func checkBorrowerContact(for borrowerVM: BorrowerVM) {
        print("checkBorrowerContact ...")
        let contact = getBorrowerContact(for: borrowerVM)
        if let contact = contact {
            let contactName = "\(contact.givenName) \(contact.familyName)"
            if borrowerVM.name != contactName {
                borrowerVM.name = contactName
            }
        }
    }
    func getBorrowerContactVM(for borrower: BorrowerModel) -> ContactVM {
        contactsVMs.first(where: { $0.contact.identifier == borrower.contactId } ) ?? ContactVM()
    }
}
