//
//  BorrowerVM.swift
//  Lentit
//
//  Created by William Mead on 07/04/2022.
//

import Foundation
import Contacts
/// Borrower view model
final class BorrowerVM: ViewModelProtocol, ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Properties
    typealias ModelType = BorrowerModel
    internal var model: ModelType
    internal var id: UUID
    internal var loanIds: Set<UUID>
    @Published var firstName: String
    @Published var lastName: String
    @Published var thumbnailImage: Data?
    @Published var status: StatusModel
    @Published var loanCount: Int
    @Published var contactLink: Bool {
        didSet {
            if !contactLink {
                contactId = nil
            }
        }
    }
    @Published var contactId: String?
    @Published var editDisabled: Bool {
        didSet {
            if editDisabled {
                updateModel()
            }
        }
    }
    @Published var navigationLinkActive: Bool {
        didSet {
            if !navigationLinkActive {
                editDisabled = true
            }
        }
    }
// MARK: - Init & deinit
    init() {
        print("BorrowerVM init ...")
        self.model = BorrowerModel.defaultData
        self.id = BorrowerModel.defaultData.id
        self.firstName = BorrowerModel.defaultData.firstName
        self.lastName = BorrowerModel.defaultData.lastName
        self.thumbnailImage = BorrowerModel.defaultData.thumbnailImage
        self.status = BorrowerModel.defaultData.status
        self.loanCount = 0
        self.contactLink = BorrowerModel.defaultData.contactLink
        self.contactId = BorrowerModel.defaultData.contactId
        self.loanIds = BorrowerModel.defaultData.loanIds
        self.editDisabled = true
        self.navigationLinkActive = false
    }
    deinit {
        print("... deinit BorrowerVM \(id)")
    }
// MARK: - Methods
    func setVM(from model: ModelType) {
        print("setVM \(model.id)...")
        self.model = model
        self.id = model.id // Shared with borrower data object
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.thumbnailImage = model.thumbnailImage
        self.status = model.status
        self.loanCount = countBorrowerLoans(for: model)
        self.contactLink = model.contactLink
        self.contactId = model.contactId
        self.loanIds = model.loanIds
        print("... setVM Borrower \(id)")
    }
    func updateModel() {
        print("updateModel \(self.id) ...")
        self.model.id = self.id
        self.model.firstName = self.firstName
        self.model.lastName = self.lastName
        self.model.thumbnailImage = self.thumbnailImage
        self.model.status = self.status
        self.model.contactLink = self.contactLink
        self.model.contactId = self.contactId
        self.model.loanIds = self.loanIds
    }
    func countBorrowerLoans(for borrower: BorrowerModel) -> Int {
        borrower.loanIds.count
    }
    func updateVM(from contactVM: ContactVM) {
        print("updateVM ...")
        self.firstName = contactVM.firstName
        self.lastName = contactVM.lastName
        self.thumbnailImage = contactVM.thumbnailImageData
        self.contactId = contactVM.model.identifier
    }
    func updateBorrowerLoans(with loanVMId: UUID) {
        self.loanIds.insert(loanVMId)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
}
