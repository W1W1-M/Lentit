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
    private(set) var loan: LoanModel
    private(set) var id: UUID
    @Published var loanDate: Date {
        didSet{
            loan.loanDate = self.loanDate
            loanDateText = setLoanDateText(for: loanDate)
        }
    }
    @Published var loanDateText: String
    @Published var reminder: Date {
        didSet{
            loan.reminder = self.reminder
        }
    }
    @Published var reminderActive: Bool {
        didSet{
            loan.reminderActive = self.reminderActive
        }
    }
    @Published var returned: Bool {
        didSet{
            loan.returned = self.returned
            setReturnedLoanStatus()
        }
    }
    @Published var status: LoanStatusModel {
        didSet{
            loan.status = self.status
        }
    }
    @Published var itemVM: ItemVM
    @Published var borrowerVM: BorrowerVM
    // MARK: - Init
    init() {
        self.loan = LoanModel.defaultData
        self.id = LoanModel.defaultData.id
        self.loanDate = LoanModel.defaultData.loanDate
        self.loanDateText = "\(LoanModel.defaultData.loanDate)"
        self.reminder = LoanModel.defaultData.reminder
        self.reminderActive = LoanModel.defaultData.reminderActive
        self.returned = LoanModel.defaultData.returned
        self.status = LoanModel.defaultData.status
        self.itemVM = ItemVM()
        self.borrowerVM = BorrowerVM()
        //
        self.loanDateText = setLoanDateText(for: loanDate)
    }
    // MARK: - Functions
    func setLoanVM(from loanModel: LoanModel, _ itemVM: ItemVM, _ borrowerVM: BorrowerVM) {
        self.loan = loanModel
        self.id = loanModel.id
        self.loanDate = loanModel.loanDate
        self.reminder = loanModel.reminder
        self.reminderActive = loanModel.reminderActive
        self.returned = loanModel.returned
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
        self.loan.borrowerId = self.borrowerVM.id
    }
    func setLoanItem(to newItemVM: ItemVM) {
        self.itemVM = newItemVM
        self.loan.itemId = self.itemVM.id
    }
    func setReturnedLoanStatus() {
        if(returned) {
            self.status = LoanStatus.finished
        } else if(!returned && status == LoanStatus.finished) {
            self.status = LoanStatus.current
        }
    }
}
