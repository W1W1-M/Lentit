//
//  LoanVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Loan view model
class LoanVM: ObservableObject, Identifiable {
    // MARK: - Variables
    var loan: LoanModel
    @Published var id: UUID
    @Published var loanDate: Date {
        didSet{
            loan.loanDate = loanDate
        }
    }
    @Published var reminder: Date {
        didSet{
            loan.reminder = reminder
        }
    }
    @Published var returnedSold: Bool {
        didSet{
            loan.returnedSold = returnedSold
        }
    }
    @Published var justAdded: Bool {
        didSet{
            loan.justAdded = justAdded
        }
    }
    @Published var itemVM: ItemVM
    @Published var borrowerVM: BorrowerVM {
        didSet{
            loan.borrowerId = borrowerVM.id
        }
    }
    // MARK: - Init
    init() {
        self.loan = DataStoreModel.sampleLoanData[0]
        self.id = UUID()
        self.loanDate = Date()
        self.reminder = Date()
        self.returnedSold = false
        self.justAdded = false
        self.itemVM = ItemVM()
        self.borrowerVM = BorrowerVM()
    }
    // MARK: - Functions
    func setLoanVM(from loanModel: LoanModel, _ itemVM: ItemVM, _ borrowerVM: BorrowerVM) {
        self.loan = loanModel
        self.id = loanModel.id
        self.loanDate = loanModel.loanDate
        self.reminder = loanModel.reminder
        self.returnedSold = loanModel.returnedSold
        self.justAdded = loanModel.justAdded
        self.itemVM = itemVM
        self.borrowerVM = borrowerVM
    }
    func setLoanDateText(for loanDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let loanDateText: String = dateFormat.string(from: loanDate)
        return loanDateText
    }
    func setLoanExpiryText(for loanExpiry: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let loanExpiryText: String = dateFormat.string(from: loanExpiry)
        return loanExpiryText
    }
    func setLoanTimeText(for loanTime: TimeInterval) -> String {
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .short
        timeFormat.allowedUnits = [.day, .month, .year]
        if let loanTime = timeFormat.string(from: loanTime) {
            let loanTimeText = loanTime
            return loanTimeText
        } else {
            let loanTimeText = ""
            return loanTimeText
        }
    }
    func setLoanTime(from loanDate: Date, to loanExpiry: Date) -> TimeInterval {
        let loanTime = loanExpiry.timeIntervalSince(loanDate)
        return loanTime
    }
    func setLoanBorrower(to newBorrowerVM: BorrowerVM) {
        self.borrowerVM = newBorrowerVM
    }
}
