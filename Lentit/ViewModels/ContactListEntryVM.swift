//
//  ContactListEntryVM.swift
//  Lentit
//
//  Created by William Mead on 18/04/2022.
//

import Foundation
import Contacts
/// Description
final class ContactListEntryVM: ViewModel, ObservableObject {
    // MARK: - Properties
    private(set) var contact: CNContact?
    @Published var name: String
    @Published var borrowerContactLink: Bool
    // MARK: - Init & deinit
    override init() {
        print("ContactListEntryVM init ...")
        self.contact = nil
        self.name = ""
        self.borrowerContactLink = false
        super.init()
    }
    deinit {
        print("... deinit ContactListEntryVM")
    }
    // MARK: - Methods
    func setVM(contact: CNContact) {
        print("setVM \(contact.identifier) ...")
        self.contact = contact
        self.id = UUID(uuidString: contact.identifier) ?? UUID()
        self.name = "\(contact.givenName) \(contact.familyName)"
        self.borrowerContactLink = false
    }
}
