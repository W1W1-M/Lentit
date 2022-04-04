//
//  BorrowerListEntryVM.swift
//  Lentit
//
//  Created by William Mead on 04/04/2022.
//

import Foundation
/// Description
class BorrowerListEntryVM: ObservableObject, Identifiable {
    // MARK: - Properties
    private(set) var borrower: BorrowerModel
    private(set) var id: UUID
    @Published var name: String
    @Published var status: BorrowerModel.Status
    @Published var loanCount: Int
    // MARK: - Custom initializer
    init() {
        self.borrower = BorrowerModel.defaultData
        self.id = UUID()
        self.name = BorrowerModel.defaultData.name
        self.status = BorrowerModel.defaultData.status
        self.loanCount = 0
    }
    // MARK: - Methods
    func setVM(from borrower: BorrowerModel) {
        self.borrower = borrower
        self.id = borrower.id
        self.name = borrower.name
        self.status = borrower.status
        self.loanCount = borrower.loanIds.count
    }
}
