//
//  LoanListVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
// MARK: - Classes
/// Loan list view model
class LoanListVM: ObservableObject {
// MARK: - Properties
    @Published var loansCount: Int
// MARK: - Custom initializer
    init() {
        self.loansCount = 0
    }
// MARK: - Methods
    func setLoansCount(for LoanListEntryVMs: [LoanListEntryVM]) {
        self.loansCount = LoanListEntryVMs.count
    }
    
}
