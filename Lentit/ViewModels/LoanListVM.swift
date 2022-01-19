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
    @Published var loansCountText: String
    // MARK: - Init
    init() {
        self.loansCountText = ""
    }
    // MARK: - Functions
    /// <#Description#>
    /// - Parameter loansVMs: <#loansVMs description#>
    func setLoansCount(for loanVMs: [LoanVM]) {
        self.loansCountText = "\(loanVMs.count)"
    }
    
}
