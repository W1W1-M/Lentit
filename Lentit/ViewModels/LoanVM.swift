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
            loan.loanDate = self.loanDate
        }
    }
    @Published var reminder: Date {
        didSet{
            loan.reminder = self.reminder
        }
    }
    @Published var returnedSold: Bool {
        didSet{
            loan.returnedSold = self.returnedSold
            setReturnedSoldLoanStatus()
        }
    }
    @Published var status: LoanStatusModel {
        didSet{
            loan.status = self.status
        }
    }
    @Published var itemVM: ItemVM {
        didSet{
            loan.itemId = self.itemVM.id
        }
    }
    @Published var borrowerVM: BorrowerVM {
        didSet{
            loan.borrowerId = self.borrowerVM.id
        }
    }
    // MARK: - Init
    init() {
        self.loan = DataStoreModel.defaultLoanData
        self.id = DataStoreModel.defaultLoanData.id
        self.loanDate = DataStoreModel.defaultLoanData.loanDate
        self.reminder = DataStoreModel.defaultLoanData.reminder
        self.returnedSold = DataStoreModel.defaultLoanData.returnedSold
        self.status = DataStoreModel.defaultLoanData.status
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
        self.status = loanModel.status
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
    func setLoanItem(to newItemVM: ItemVM) {
        self.itemVM = newItemVM
    }
    func setReturnedSoldLoanStatus() {
        if(returnedSold) {
            self.status = LoanStatus.finished
        } else if(!returnedSold && status == LoanStatus.finished) {
            self.status = LoanStatus.current
        }
    }
}
