//
//  BorrowerListVM.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import Foundation

/// Borrowers list view model
class BorrowerListVM: ObservableObject {
    // MARK: - Variables
    @Published var borrowersCountText: String
    // MARK: - Init
    init() {
        self.borrowersCountText = "0"
    }
    // MARK: - Functions
    func setBorrowersCount(for borrowerVMs: [BorrowerVM]) {
        self.borrowersCountText = "\(borrowerVMs.count)"
    }
}
