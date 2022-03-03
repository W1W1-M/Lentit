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
    // MARK: - Variables
    @Published var loansCount: Int
    @Published var loansCountText: String
    // MARK: - Init
    init() {
        self.loansCount = 0
        self.loansCountText = "0"
    }
    // MARK: - Functions
    /// <#Description#>
    /// - Parameter loansVMs: <#loansVMs description#>
    func setLoansCount(for loanVMs: [LoanVM]) {
        self.loansCount = loanVMs.count
        self.loansCountText = "\(loansCount)"
    }
    
}
