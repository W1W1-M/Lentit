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
    @Published var name: String {
        didSet {
            self.model.name = name
        }
    }
    @Published var status: StatusModel {
        didSet {
            self.model.status = status
        }
    }
    @Published var loanCount: Int
    @Published var contactLink: Bool
// MARK: - Init & deinit
    init() {
        print("BorrowerVM init ...")
        self.model = BorrowerModel.defaultBorrowerData
        self.id = BorrowerModel.defaultBorrowerData.id
        self.name = BorrowerModel.defaultBorrowerData.name
        self.status = BorrowerModel.defaultBorrowerData.status
        self.loanCount = 0
        self.contactLink = BorrowerModel.defaultBorrowerData.contactLink
        self.loanIds = BorrowerModel.defaultBorrowerData.loanIds
    }
    deinit {
        print("... deinit BorrowerVM \(id)")
    }
// MARK: - Methods
    func setVM(from model: ModelType) {
        print("setVM ...")
        self.model = model
        self.id = model.id // Shared with borrower data object
        self.name = model.name
        self.status = model.status
        self.loanCount = countBorrowerLoans(for: model)
        self.contactLink = model.contactLink
        self.loanIds = model.loanIds
        print("... setVM Borrower \(id)")
    }
    func countBorrowerLoans(for borrower: BorrowerModel) -> Int {
        borrower.loanIds.count
    }
    func updateName(to newName: String) {
        self.name = newName
    }
    func updateBorrowerLoans(with loanVMId: UUID) {
        self.loanIds.insert(loanVMId)
        self.model.loanIds = self.loanIds
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
}
