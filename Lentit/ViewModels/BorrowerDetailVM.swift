//
//  BorrowerDetailVM.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Borrower view model
final class BorrowerDetailVM: BorrowerVM {
// MARK: - Properties
    private(set) var loanIds: Set<UUID>
// MARK: - Init & deinit
    override init() {
        print("BorrowerDetailVM init ...")
        self.loanIds = BorrowerModel.defaultData.loanIds
        super.init()
    }
    deinit {
        print("... deinit BorrowerDetailVM")
    }
// MARK: - Methods
    func setDetailVM(from borrowerModel: BorrowerModel) {
        self.loanIds = borrowerModel.loanIds
    }
    func updateBorrowerLoans(with loanVMId: UUID) {
        self.loanIds.insert(loanVMId)
        self.borrower.loanIds = self.loanIds
    }
}
