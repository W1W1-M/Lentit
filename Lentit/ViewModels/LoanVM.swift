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
            self.loanBorrowerName = loanBorrower.firstName
        }
    }
    @Published var loanDate: Date {
        didSet{
            loanDateText = setLoanDateText(for: loanDate)
        }
    }
    @Published var loanDateText: String
    @Published var returned: Bool {
        didSet{
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
    @Published var editDisabled: Bool {
        didSet {
            if editDisabled {
                updateModel()
            }
        }
    }
    @Published var navigationLinkActive: Bool {
        didSet {
            if !navigationLinkActive {
                editDisabled = true
            }
        }
    }
// MARK: - Init & deinit
    init() {
        print("LoanVM init ...")
        self.model = LoanModel.defaultData
        self.id = LoanModel.defaultData.id
        self.loanItem = ItemModel.defaultData
        self.loanBorrower = BorrowerModel.defaultData
        self.loanDate = LoanModel.defaultData.loanDate
        self.loanDateText = "\(LoanModel.defaultData.loanDate)"
        self.returned = LoanModel.defaultData.returned
        self.status = LoanModel.defaultData.status
        self.loanBorrowerName = BorrowerModel.defaultData.firstName
        self.loanItemName = ItemModel.defaultData.name
        self.loanItemCategory = ItemModel.defaultData.category
        self.editDisabled = true
        self.navigationLinkActive = false
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
        self.loanBorrowerName = loanBorrower.firstName
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
    static func == (lhs: LoanVM, rhs: LoanVM) -> Bool {
        lhs.id == rhs.id
    }
}
