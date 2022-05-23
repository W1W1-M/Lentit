//
//  BorrowerListVM.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import Foundation
/// Borrowers list view model
final class BorrowerListVM: ObservableObject {
// MARK: - Properties
    @Published var borrowersCount: Int
    @Published var newBorrowerPresented: Bool
    @Published var newBorrowerId: UUID
    @Published var newBorrowerName: String
    @Published var newBorrowerStatus: StatusModel
// MARK: - Init & deinit
    init() {
        print("BorrowerListVM init ...")
        self.borrowersCount = 0
        self.newBorrowerPresented = false
        self.newBorrowerId = UUID()
        self.newBorrowerName = ""
        self.newBorrowerStatus = .regular
    }
    deinit {
        print("... deinit BorrowerListVM")
    }
// MARK: - Methods
    func setBorrowersCount(for borrowerVMs: [BorrowerVM]) {
        self.borrowersCount = borrowerVMs.count
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
