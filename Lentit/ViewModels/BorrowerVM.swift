//
//  BorrowerVM.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Borrower view model
class BorrowerVM: ObservableObject, Identifiable, Equatable, Hashable {
    // MARK: - Variables
    private(set) var borrower: BorrowerModel
    private(set) var id: UUID
    private(set) var loanIds: Set<UUID>
    @Published var nameText: String {
        didSet{
            borrower.name = self.nameText
        }
    }
    @Published var status: BorrowerModel.Status {
        didSet{
            borrower.status = self.status
        }
    }
    @Published var loanCount: Int
    // MARK: - Init
    init() {
        self.borrower = BorrowerModel.defaultData
        self.id = BorrowerModel.defaultData.id
        self.loanIds = BorrowerModel.defaultData.loanIds
        self.nameText = BorrowerModel.defaultData.name
        self.status = BorrowerModel.defaultData.status
        self.loanCount = 0
        //
        self.loanCount = countBorrowerLoans()
    }
    // MARK: - Functions
    func setBorrowerVM(from borrowerModel: BorrowerModel) {
        self.borrower = borrowerModel
        self.id = borrowerModel.id // Shared with borrower data object
        self.loanIds = borrowerModel.loanIds
        self.nameText = borrowerModel.name
        self.status = borrowerModel.status
        self.loanCount = countBorrowerLoans()
    }
    func countBorrowerLoans() -> Int {
        self.loanIds.count
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
