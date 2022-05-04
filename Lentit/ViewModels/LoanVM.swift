//
//  LoanVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
import EventKit
/// Loan view model
final class LoanVM: ViewModelProtocol, ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Properties
    typealias ModelType = LoanModel
    internal var model: ModelType
    internal var id: UUID
    internal var loanItem: ItemModel {
        didSet {
            self.loanItemName = loanItem.name
        }
    }
    internal var loanBorrower: BorrowerModel {
        didSet {
            self.loanBorrowerName = loanBorrower.name
        }
    }
    @Published var loanDate: Date {
        didSet{
            model.loanDate = self.loanDate
            loanDateText = setLoanDateText(for: loanDate)
        }
    }
    @Published var loanDateText: String
    @Published var returned: Bool {
        didSet{
            model.returned = self.returned
            setReturnedLoanStatus()
        }
    }
    @Published var status: StatusModel {
        didSet {
            self.model.status = status
        }
    }
    @Published var loanBorrowerName: String
    @Published var loanItemName: String
    @Published var loanItemCategory: ItemModel.Category
// MARK: - Init & deinit
    init() {
        print("LoanVM init ...")
        self.model = LoanModel.defaultLoanData
        self.id = LoanModel.defaultLoanData.id
        self.loanItem = ItemModel.defaultItemData
        self.loanBorrower = BorrowerModel.defaultBorrowerData
        self.loanDate = LoanModel.defaultLoanData.loanDate
        self.loanDateText = "\(LoanModel.defaultLoanData.loanDate)"
        self.returned = LoanModel.defaultLoanData.returned
        self.status = LoanModel.defaultLoanData.status
        self.loanBorrowerName = BorrowerModel.defaultBorrowerData.name
        self.loanItemName = ItemModel.defaultItemData.name
        self.loanItemCategory = ItemModel.defaultItemData.category
        //
        self.loanDateText = setLoanDateText(for: loanDate)
    }
    deinit {
        print("... deinit LoanVM \(id)")
    }
// MARK: - Methods
    func setVM(from model: ModelType) {
        self.model = model
        self.id = model.id
        self.loanDate = model.loanDate
        self.returned = model.returned
        self.status = model.status
    }
    func updateModel() {
        print("updateModel \(self.id)...")
    }
    func setVM(from loan: LoanModel, _ loanItem: ItemModel, _ loanBorrower: BorrowerModel) {
        print("setVM ...")
        setVM(from: loan)
        self.loanItem = loanItem
        self.loanBorrower = loanBorrower
        self.loanBorrowerName = loanBorrower.name
        self.loanItemName = loanItem.name
        self.loanItemCategory = loanItem.category
        print("... setVM Loan \(id)")
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
        self.model.updateBorrowerId(self.loanBorrower.id)
    }
    func setLoanItem(to newItem: ItemModel) {
        self.loanItem = newItem
        self.loanItem.addLoanId(with: self.id)
        self.model.updateItemId(self.loanItem.id)
    }
    func setReturnedLoanStatus() {
        if(returned) {
            self.status = StatusModel.finished
        } else if(!returned && status == StatusModel.finished) {
            self.status = StatusModel.current
        }
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: LoanVM, rhs: LoanVM) -> Bool {
        lhs.id == rhs.id
    }
}
