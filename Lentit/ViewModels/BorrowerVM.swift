//
//  BorrowerVM.swift
//  Lentit
//
//  Created by William Mead on 07/04/2022.
//

import Foundation
/// Borrower view model
class BorrowerVM: ViewModel, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    private(set) var borrower: BorrowerModel
    @Published var name: String {
        didSet {
            self.borrower.name = name
        }
    }
    @Published var status: StatusModel
    @Published var loanCount: Int
    @Published var contactLink: Bool
// MARK: - Init & deinit
    override init() {
        print("BorrowerVM init ...")
        self.borrower = BorrowerModel.defaultData
        self.name = BorrowerModel.defaultData.name
        self.status = StatusModel.unknown
        self.loanCount = 0
        self.contactLink = BorrowerModel.defaultData.contactLink
        super.init()
    }
    deinit {
        print("... deinit BorrowerVM")
    }
// MARK: - Methods
    func setVM(from borrowerModel: BorrowerModel) {
        self.borrower = borrowerModel
        self.id = borrowerModel.id // Shared with borrower data object
        self.name = borrowerModel.name
        self.status = borrowerModel.status
        self.loanCount = countBorrowerLoans(for: borrowerModel)
        self.contactLink = borrowerModel.contactLink
    }
    func countBorrowerLoans(for borrower: BorrowerModel) -> Int {
        borrower.loanIds.count
    }
    func updateName(to newName: String) {
        self.name = newName
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerVM, rhs: BorrowerVM) -> Bool {
        lhs.id == rhs.id
    }
}
