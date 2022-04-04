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
    @Published var newBorrowerPresented: Bool
    @Published var newBorrowerId: UUID
    @Published var newBorrowerName: String
    // MARK: - Init
    init() {
        self.borrowersCount = 0
        self.newBorrowerPresented = false
        self.newBorrowerId = UUID()
        self.newBorrowerName = ""
    }
    // MARK: - Functions
    func setBorrowersCount(for borrowerListEntryVMs: [BorrowerListEntryVM]) {
        self.borrowersCount = borrowerListEntryVMs.count
    }
    func showNewBorrower() {
        resetNewBorrower()
        self.newBorrowerPresented = true
    }
    func hideNewBorrower() {
        resetNewBorrower()
        self.newBorrowerPresented = false
    }
    func resetNewBorrower() {
        self.newBorrowerId = UUID()
        self.newBorrowerName = ""
    }
}
