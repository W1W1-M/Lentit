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
            borrower.name = nameText
        }
    }
    // MARK: - Init
    init() {
        self.borrower = DataStoreModel.sampleBorrowerData[0]
        self.id = UUID()
        self.nameText = "🤷 Unknown"
    }
    // MARK: - Functions
    func setBorrowerVM(for borrowerModel: BorrowerModel) {
        self.borrower = borrowerModel
        self.id = borrowerModel.id // Shared with borrower data object
        self.nameText = borrowerModel.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
    
}
