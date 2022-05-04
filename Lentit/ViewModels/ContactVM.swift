//
//  ContactVM.swift
//  Lentit
//
//  Created by William Mead on 18/04/2022.
//

import Foundation
import Contacts
/// Description
final class ContactVM: ObservableObject, Identifiable, Equatable, Comparable {
    // MARK: - Properties
    internal var id: UUID
    internal var contact: CNContact
    @Published var name: String
    @Published var borrowerContactLink: Bool
    // MARK: - Init & deinit
    init() {
        print("ContactVM init ...")
        self.id = UUID()
        self.contact = CNContact()
        self.name = ""
        self.borrowerContactLink = false
    }
    deinit {
        print("... deinit ContactVM \(id)")
    }
    // MARK: - Methods
    func setVM(contact: CNContact) {
        print("setVM \(contact.identifier) ...")
        self.contact = contact
        self.id = UUID(uuidString: contact.identifier) ?? UUID()
        self.name = "\(contact.givenName) \(contact.familyName)"
        self.borrowerContactLink = false
    }
    static func == (lhs: ContactVM, rhs: ContactVM) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: ContactVM, rhs: ContactVM) -> Bool {
        lhs.name < rhs.name
    }
}
