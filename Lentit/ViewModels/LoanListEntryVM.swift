//
//  LoanListEntryVM.swift
//  Lentit
//
//  Created by William Mead on 03/04/2022.
//

import Foundation
/// Loan list entry view model
final class LoanListEntryVM: ObservableObject, Identifiable {
// MARK: - Properties
    private(set) var loan: LoanModel
    private(set) var id: UUID
    private(set) var loanDate: Date
    @Published var loanDateText: String
    @Published var loanStatus: LoanModel.Status
    @Published var itemName: String
    @Published var itemCategory: ItemModel.Category
    @Published var borrowerName: String
// MARK: - Init & deinit
    init() {
        print("LoanListEntryVM init ...")
        self.loan = LoanModel.defaultData
        self.id = UUID()
        self.loanDate = LoanModel.defaultData.loanDate
        self.loanDateText = ""
        self.loanStatus = LoanModel.defaultData.status
        self.itemName = ItemModel.defaultData.name
        self.itemCategory = ItemModel.defaultData.category
        self.borrowerName = BorrowerModel.defaultData.name
        //
        self.loanDateText = setLoanDateText(for: self.loanDate)
    }
    deinit {
        print("... deinit LoanListEntryVM \(id)")
    }
// MARK: - Methods
    func setVM(from loan: LoanModel, _ item: ItemModel, _ borrower: BorrowerModel) {
        print("setVM \(loan.id) ...")
        self.loan = loan
        self.id = loan.id
        self.loanDate = loan.loanDate
        self.loanDateText = setLoanDateText(for: self.loanDate)
        self.loanStatus = loan.status
        self.itemName = item.name
        self.itemCategory = item.category
        self.borrowerName = borrower.name
    }
    func setLoanDateText(for loanDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let loanDateText: String = dateFormat.string(from: loanDate)
        return loanDateText
    }
}
