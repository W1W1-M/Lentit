//
//  BorrowerVM.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Borrower view model
class BorrowerVM: ObservableObject, Identifiable, Equatable, Hashable {
    // MARK: - Variables
    private(set) var borrower: BorrowerModel
    private(set) var id: UUID
    @Published var nameText: String {
        didSet{
            borrower.name = self.nameText
        }
    }
    @Published var status: BorrowerModel.Status {
        didSet{
            borrower.status = self.status
        }
    }
    // MARK: - Init
    init() {
        self.borrower = BorrowerModel.defaultData
        self.id = BorrowerModel.defaultData.id
        self.nameText = BorrowerModel.defaultData.name
        self.status = BorrowerModel.defaultData.status
    }
    // MARK: - Functions
    func setBorrowerVM(for borrowerModel: BorrowerModel) {
        self.borrower = borrowerModel
        self.id = borrowerModel.id // Shared with borrower data object
        self.nameText = borrowerModel.name
        self.status = borrowerModel.status
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
}
