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
    var borrower: BorrowerModel
    @Published var id: UUID
    @Published var nameText: String {
        didSet{
            borrower.name = self.nameText
        }
    }
    @Published var status: BorrowerStatusModel {
        didSet{
            borrower.status = self.status
        }
    }
    // MARK: - Init
    init() {
        self.borrower = DataStoreModel.defaultBorrowerData
        self.id = DataStoreModel.defaultBorrowerData.id
        self.nameText = DataStoreModel.defaultBorrowerData.name
        self.status = DataStoreModel.defaultBorrowerData.status
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
