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
    @Published var borrowersCount: Int
    @Published var borrowersCountText: String
    @Published var newBorrowerPresented: Bool
    @Published var newBorrowerName: String
    // MARK: - Init
    init() {
        self.borrowersCount = 0
        self.borrowersCountText = "0"
        self.newBorrowerPresented = false
        self.newBorrowerName = ""
    }
    // MARK: - Functions
    func setBorrowersCount(for borrowerVMs: [BorrowerVM]) {
        self.borrowersCount = borrowerVMs.count
        self.borrowersCountText = "\(borrowersCount)"
    }
    func showNewBorrower() {
        self.newBorrowerName = ""
        self.newBorrowerPresented = true
    }
    func hideNewBorrower() {
        self.newBorrowerName = ""
        self.newBorrowerPresented = false
    }
}
