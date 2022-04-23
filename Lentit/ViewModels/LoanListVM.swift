//
//  LoanListVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Loan list view model
class LoanListVM: ObservableObject {
// MARK: - Properties
    @Published var loansCount: Int
// MARK: - Init & deinit
    init() {
        print("LoanListVM init ...")
        self.loansCount = 0
    }
    deinit {
        print("... deinit LoanListVM")
    }
// MARK: - Methods
    func setLoansCount(for LoanVMs: [LoanVM]) {
        self.loansCount = LoanVMs.count
    }
    
}
