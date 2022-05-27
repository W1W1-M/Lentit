//
//  ContactVM.swift
//  Lentit
//
//  Created by William Mead on 18/04/2022.
//

import Foundation
import Contacts
/// Description
final class ContactVM: ViewModelProtocol, ObservableObject, Identifiable, Equatable, Comparable, Hashable {
    // MARK: - Properties
    typealias ModelType = CNContact
    internal var id: UUID
    internal var model: CNContact
    internal var phoneNumbers: Array<CNLabeledValue<CNPhoneNumber>>?
    internal var emailAddresses: Array<CNLabeledValue<NSString>>?
    @Published var firstName: String
    @Published var lastName: String
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
    var status: StatusModel
    var editDisabled: Bool
    var navigationLinkActive: Bool
    // MARK: - Init & deinit
    init() {
        print("ContactVM init ...")
        self.id = UUID()
        self.model = CNContact()
        self.phoneNumbers = nil
        self.emailAddresses = nil
        self.firstName = ""
        self.lastName = ""
        self.borrowerContactLink = false
        self.thumbnailImageData = nil
        self.status = .unknown
        self.editDisabled = false
        self.navigationLinkActive = false
    }
    deinit {
        print("... deinit ContactVM \(id)")
    }
    // MARK: - Methods
    func setVM(from model: ModelType) {
        print("setVM \(model.identifier) ...")
        self.id = UUID(uuidString: model.identifier) ?? UUID()
        self.model = model
        self.phoneNumbers = model.phoneNumbers
        self.emailAddresses = model.emailAddresses
        self.firstName = model.givenName
        self.lastName = model.familyName
        self.borrowerContactLink = false
        self.thumbnailImageData = model.thumbnailImageData
    }
    func updateModel() {
        print("updateModel ...")
    }
    static func == (lhs: ContactVM, rhs: ContactVM) -> Bool {
        lhs.id == rhs.id
    }
    static func < (lhs: ContactVM, rhs: ContactVM) -> Bool {
        lhs.firstName < rhs.firstName
    }
}
