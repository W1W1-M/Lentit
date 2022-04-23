//
//  BorrowerVM.swift
//  Lentit
//
//  Created by William Mead on 07/04/2022.
//

import Foundation
/// Borrower view model
class BorrowerVM: ViewModel, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    private(set) var borrower: BorrowerModel
    @Published var name: String {
        didSet {
            self.borrower.name = name
        }
    }
    @Published var loanCount: Int
    @Published var contactLink: Bool
    private(set) var loanIds: Set<UUID>
// MARK: - Init & deinit
    override init() {
        print("BorrowerVM init ...")
        self.borrower = BorrowerModel.defaultBorrowerData
        self.name = BorrowerModel.defaultBorrowerData.name
        self.loanCount = 0
        self.contactLink = BorrowerModel.defaultBorrowerData.contactLink
        self.loanIds = BorrowerModel.defaultBorrowerData.loanIds
        super.init()
    }
    deinit {
        print("... deinit BorrowerVM \(id)")
    }
// MARK: - Methods
    func setVM(from borrower: BorrowerModel) {
        self.model = borrower
        self.borrower = borrower
        self.id = borrower.id // Shared with borrower data object
        self.name = borrower.name
        self.status = borrower.status
        self.loanCount = countBorrowerLoans(for: borrower)
        self.contactLink = borrower.contactLink
        self.loanIds = borrower.loanIds
    }
    func countBorrowerLoans(for borrower: BorrowerModel) -> Int {
        borrower.loanIds.count
    }
    func updateName(to newName: String) {
        self.name = newName
    }
    func updateBorrowerLoans(with loanVMId: UUID) {
        self.loanIds.insert(loanVMId)
        self.borrower.loanIds = self.loanIds
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
}
