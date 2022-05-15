//
//  BorrowerVM.swift
//  Lentit
//
//  Created by William Mead on 07/04/2022.
//

import Foundation
/// Borrower view model
final class BorrowerVM: ViewModelProtocol, ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Properties
    typealias ModelType = BorrowerModel
    internal var model: ModelType
    internal var id: UUID
    internal var loanIds: Set<UUID>
    @Published var name: String
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
        self.model = BorrowerModel.defaultBorrowerData
        self.id = BorrowerModel.defaultBorrowerData.id
        self.name = BorrowerModel.defaultBorrowerData.name
        self.status = BorrowerModel.defaultBorrowerData.status
        self.loanCount = 0
        self.contactLink = BorrowerModel.defaultBorrowerData.contactLink
        self.contactId = nil
        self.loanIds = BorrowerModel.defaultBorrowerData.loanIds
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
        self.name = model.name
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
        self.model.name = self.name
        self.model.status = self.status
        self.model.contactLink = self.contactLink
        self.model.contactId = self.contactId
        self.model.loanIds = self.loanIds
    }
    func countBorrowerLoans(for borrower: BorrowerModel) -> Int {
        borrower.loanIds.count
    }
    func updateName(to newName: String) {
        print("updateName \(newName) ...")
        self.name = newName
    }
    func updateContactId(to newContactId: String) {
        print("updateContactId \(newContactId) ...")
        self.contactId = newContactId
    }
    func updateBorrowerLoans(with loanVMId: UUID) {
        self.loanIds.insert(loanVMId)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
}
