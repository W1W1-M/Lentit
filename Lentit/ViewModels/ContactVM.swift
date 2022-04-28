//
//  ContactVM.swift
//  Lentit
//
//  Created by William Mead on 18/04/2022.
//

import Foundation
import Contacts
/// Description
final class ContactVM: ObservableObject, Identifiable {
    // MARK: - Properties
    internal var id: UUID
    internal var contact: CNContact?
    @Published var name: String
    @Published var borrowerContactLink: Bool
    // MARK: - Init & deinit
    init() {
        print("ContactVM init ...")
        self.id = UUID()
        self.contact = nil
        self.name = ""
        self.borrowerContactLink = false
    }
    deinit {
        print("... deinit ContactVM")
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
