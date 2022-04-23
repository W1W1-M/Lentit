//
//  LoanModel.swift
//  Lentit
//
//  Created by William Mead on 17/01/2022.
//

import Foundation
import EventKit
/// Data model for a item loan
final class LoanModel: Model, ObservableObject, Equatable {
// MARK: - Properties
    var loanDate: Date
    var loanTime: TimeInterval
    var loanExpiry: Date {
        loanDate.addingTimeInterval(loanTime)
    }
    var ekReminderId: String?
    var reminderDate: Date?
    var reminderActive: Bool
    var returned: Bool
    var itemId: UUID?
    var borrowerId: UUID?
// MARK: - Init & deinit
    init(
        loanDate: Date,
        loanTime: TimeInterval,
        ekReminderId: String?,
        reminderDate: Date?,
        reminderActive: Bool,
        returned: Bool,
        status: StatusModel,
        itemId: UUID?,
        borrowerId: UUID?
    ) {
        print("LoanModel init ...")
        self.loanDate = loanDate
        self.loanTime = loanTime
        self.ekReminderId = ekReminderId
        self.reminderDate = reminderDate
        self.reminderActive = reminderActive
        self.returned = returned
        self.itemId = itemId
        self.borrowerId = borrowerId
        super.init(status: status)
    }
    deinit {
        print("... deinit LoanModel")
    }
// MARK: - Methods
    static func == (lhs: LoanModel, rhs: LoanModel) -> Bool {
        lhs.id == rhs.id
    }
    func updateItemId(_ id: UUID) {
        self.itemId = id
    }
    func updateBorrowerId(_ id: UUID) {
        self.borrowerId = id
    }
}

extension LoanModel {
    /// Predefined loan sort orders
    struct SortingOrder: Identifiable, Equatable, Hashable, CaseIterable {
        let id: UUID = UUID()
        static let byItemName: SortingOrder = SortingOrder()
        static let byBorrowerName: SortingOrder = SortingOrder()
        static let byLoanDate: SortingOrder = SortingOrder()
        static let allCases: Array<SortingOrder> = [byItemName, byBorrowerName, byLoanDate]
    }
}

extension LoanModel {
    static var defaultLoanData: LoanModel = LoanModel(
        loanDate: Date(),
        loanTime: 100000.0,
        ekReminderId: nil,
        reminderDate: nil,
        reminderActive: false,
        returned: false,
        status: StatusModel.unknown,
        itemId: UUID(),
        borrowerId: UUID()
    )
}
