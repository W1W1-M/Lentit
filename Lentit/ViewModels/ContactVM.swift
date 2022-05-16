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
    internal var phoneNumbers: Array<CNLabeledValue<CNPhoneNumber>>?
    internal var emailAddresses: Array<CNLabeledValue<NSString>>?
    @Published var name: String
    @Published var borrowerContactLink: Bool
    @Published var thumbnailImageData: Data?
    internal var phoneURL: URL? {
        URL(string: "tel:\(phoneNumbers?[0].value.stringValue ?? "tel:")")
    }
    internal var messageURL: URL? {
        URL(string: "sms:\(phoneNumbers?[0].value.stringValue ?? "sms:")")
    }
    internal var facetimeURL: URL? {
        URL(string: "factime:\(phoneNumbers?[0].value.stringValue ?? "factime:")")
    }
    internal var emailURL: URL? {
        URL(string: "mailto:\(emailAddresses?[0].value ?? "mailto:")")
    }
    // MARK: - Init & deinit
    init() {
        print("ContactVM init ...")
        self.id = UUID()
        self.contact = CNContact()
        self.phoneNumbers = nil
        self.emailAddresses = nil
        self.name = ""
        self.borrowerContactLink = false
        self.thumbnailImageData = nil
    }
    deinit {
        print("... deinit ContactVM \(id)")
    }
    // MARK: - Methods
    func setVM(contact: CNContact) {
        print("setVM \(contact.identifier) ...")
        self.id = UUID(uuidString: contact.identifier) ?? UUID()
        self.contact = contact
        self.phoneNumbers = contact.phoneNumbers
        self.emailAddresses = contact.emailAddresses
        self.name = "\(contact.givenName) \(contact.familyName)"
        self.borrowerContactLink = false
        self.thumbnailImageData = contact.thumbnailImageData
    }
    static func == (lhs: ContactVM, rhs: ContactVM) -> Bool {
        lhs.id == rhs.id
    }
    static func < (lhs: ContactVM, rhs: ContactVM) -> Bool {
        lhs.name < rhs.name
    }
}
