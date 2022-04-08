//
//  LoanModel.swift
//  Lentit
//
//  Created by William Mead on 17/01/2022.
//

import Foundation
import EventKit
/// Data model for a item loan
class LoanModel: Model, ObservableObject, Identifiable, Equatable {
// MARK: - Properties
    let id: UUID
    var loanDate: Date
    var loanTime: TimeInterval
    var loanExpiry: Date {
        loanDate.addingTimeInterval(loanTime)
    }
    var reminder: EKReminder?
    var reminderActive: Bool
    var returned: Bool
    var status: StatusModel
    var itemId: UUID?
    var borrowerId: UUID?
// MARK: - Init & deinit
    init(
        loanDate: Date,
        loanTime: TimeInterval,
        reminder: EKReminder?,
        reminderActive: Bool,
        returned: Bool,
        status: StatusModel,
        itemId: UUID?,
        borrowerId: UUID?
    ) {
        print("LoanModel init ...")
        self.id = UUID()
        self.loanDate = loanDate
        self.loanTime = loanTime
        self.reminder = reminder
        self.reminderActive = reminderActive
        self.returned = returned
        self.status = status
        self.itemId = itemId
        self.borrowerId = borrowerId
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
    static var defaultData: LoanModel = LoanModel(
        loanDate: Date(),
        loanTime: 100000.0,
        reminder: EKReminder(),
        reminderActive: false,
        returned: false,
        status: StatusModel.unknown,
        itemId: UUID(),
        borrowerId: UUID()
    )
}
