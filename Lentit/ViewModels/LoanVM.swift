//
//  LoanVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
import EventKit
/// Loan view model
final class LoanVM: ViewModel, ObservableObject {
// MARK: - Properties
    private(set) var loan: LoanModel
    private(set) var loanItem: ItemModel {
        didSet {
            self.loanItemName = loanItem.name
        }
    }
    private(set) var loanBorrower: BorrowerModel {
        didSet {
            self.loanBorrowerName = loanBorrower.name
        }
    }
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
    @Published var loanBorrowerName: String
    @Published var loanItemName: String
    @Published var loanItemCategory: ItemModel.Category
// MARK: - Init & deinit
    override init() {
        print("LoanVM init ...")
        self.loan = LoanModel.defaultLoanData
        self.loanItem = ItemModel.defaultItemData
        self.loanBorrower = BorrowerModel.defaultBorrowerData
        self.loanDate = LoanModel.defaultLoanData.loanDate
        self.loanDateText = "\(LoanModel.defaultLoanData.loanDate)"
        self.returned = LoanModel.defaultLoanData.returned
        self.loanBorrowerName = BorrowerModel.defaultBorrowerData.name
        self.loanItemName = ItemModel.defaultItemData.name
        self.loanItemCategory = ItemModel.defaultItemData.category
        super.init()
        //
        self.id = LoanModel.defaultLoanData.id
        self.loanDateText = setLoanDateText(for: loanDate)
    }
    deinit {
        print("... deinit LoanVM \(id)")
    }
// MARK: - Methods
    func setVM(from loan: LoanModel, _ loanItem: ItemModel, _ loanBorrower: BorrowerModel) {
        print("setLoanVM ...")
        self.model = loan
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
