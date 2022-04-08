//
//  LoanVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
import EventKit
/// Loan view model
class LoanVM: ObservableObject, Identifiable {
// MARK: - Properties
    private(set) var loan: LoanModel
    private(set) var loanItem: ItemModel
    private(set) var loanBorrower: BorrowerModel
    private(set) var id: UUID
    @Published var loanDate: Date {
        didSet{
            loan.loanDate = self.loanDate
            loanDateText = setLoanDateText(for: loanDate)
        }
    }
    @Published var loanDateText: String
    @Published var returned: Bool {
        didSet{
            loan.returned = self.returned
            setReturnedLoanStatus()
        }
    }
    @Published var status: StatusModel {
        didSet{
            loan.status = self.status
        }
    }
    @Published var loanBorrowerName: String
    @Published var loanItemName: String
    @Published var loanItemCategory: ItemModel.Category
    @Published var reminderVM: ReminderVM
// MARK: - Init & deinit
    init() {
        print("LoanVM init ...")
        self.loan = LoanModel.defaultData
        self.loanItem = ItemModel.defaultData
        self.loanBorrower = BorrowerModel.defaultData
        self.id = LoanModel.defaultData.id
        self.loanDate = LoanModel.defaultData.loanDate
        self.loanDateText = "\(LoanModel.defaultData.loanDate)"
        self.returned = LoanModel.defaultData.returned
        self.status = LoanModel.defaultData.status
        self.loanBorrowerName = BorrowerModel.defaultData.name
        self.loanItemName = ItemModel.defaultData.name
        self.loanItemCategory = ItemModel.defaultData.category
        self.reminderVM = ReminderVM(
            loan: LoanModel.defaultData,
            reminderTitle: "\(ItemModel.Category.other.emoji) Loan to \(BorrowerModel.defaultData.name)",
            reminderNotes: ItemModel.defaultData.name
        )
        //
        self.loanDateText = setLoanDateText(for: loanDate)
    }
    deinit {
        print("... deinit LoanVM")
    }
// MARK: - Methods
    func setLoanVM(from loan: LoanModel, _ loanItem: ItemModel, _ loanBorrower: BorrowerModel) {
        print("setLoanVM ...")
        self.loan = loan
        self.loanItem = loanItem
        self.loanBorrower = loanBorrower
        self.id = loan.id
        self.loanDate = loan.loanDate
        self.returned = loan.returned
        self.status = loan.status
        self.loanBorrowerName = loanBorrower.name
        self.loanItemName = loanItem.name
        self.loanItemCategory = loanItem.category
        self.loan = loan
        self.reminderVM = ReminderVM(
            loan: loan,
            reminderTitle: "\(loanItem.category.emoji) Loan to \(loanBorrower.name)",
            reminderNotes: loanItem.name
        )
        print("... setLoanVM \(id)")
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
    func setLoanBorrower(to newBorrower: BorrowerModel) {
        self.loanBorrower = newBorrower
        self.loanBorrower.addLoanId(with: self.id)
        self.loan.updateBorrowerId(self.loanBorrower.id)
    }
    func setLoanItem(to newItem: ItemModel) {
        self.loanItem = newItem
        self.loanItem.addLoanId(with: self.id)
        self.loan.updateItemId(self.loanItem.id)
    }
    func setReturnedLoanStatus() {
        if(returned) {
            self.status = StatusModel.finished
        } else if(!returned && status == StatusModel.finished) {
            self.status = StatusModel.current
        }
    }
}
