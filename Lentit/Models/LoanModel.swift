//
//  LoanModel.swift
//  Lentit
//
//  Created by William Mead on 17/01/2022.
//

import Foundation
import EventKit
/// Data model for a item loan
final class LoanModel: ModelProtocol, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    internal var id: UUID
    internal var loanDate: Date
    internal var loanTime: TimeInterval
    internal var loanExpiry: Date {
        loanDate.addingTimeInterval(loanTime)
    }
    internal var ekReminderId: String?
    internal var reminderDate: Date?
    internal var reminderActive: Bool
    internal var returned: Bool
    internal var status: StatusModel
    internal var itemId: UUID?
    internal var borrowerId: UUID?
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
        self.id = UUID()
        self.loanDate = loanDate
        self.loanTime = loanTime
        self.ekReminderId = ekReminderId
        self.reminderDate = reminderDate
        self.reminderActive = reminderActive
        self.status = status
        self.returned = returned
        self.itemId = itemId
        self.borrowerId = borrowerId
    }
    deinit {
        print("... deinit LoanModel")
    }
// MARK: - Methods
    func updateItemId(_ id: UUID) {
        self.itemId = id
    }
    func updateBorrowerId(_ id: UUID) {
        self.borrowerId = id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: LoanModel, rhs: LoanModel) -> Bool {
        lhs.id == rhs.id
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
