//
//  LoanModel.swift
//  Lentit
//
//  Created by William Mead on 17/01/2022.
//

import Foundation
/// Data model for a item loan
class LoanModel: ObservableObject, Identifiable, Equatable {
    // MARK: - Variables
    let id: UUID
    var loanDate: Date
    var loanTime: TimeInterval
    var loanExpiry: Date {
        loanDate.addingTimeInterval(loanTime)
    }
    var reminder: Date
    var reminderActive: Bool
    var returned: Bool
    var status: LoanModel.Status
    var itemId: UUID
    var borrowerId: UUID
    // MARK: - Init
    init(
        loanDate: Date,
        loanTime: TimeInterval,
        reminder: Date,
        reminderActive: Bool,
        returned: Bool,
        status: LoanModel.Status,
        itemId: UUID,
        borrowerId: UUID
    ) {
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
    // MARK: - Functions
    static func == (lhs: LoanModel, rhs: LoanModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension LoanModel {
    /// Predefined loan status
    struct Status: Identifiable, Equatable, CaseIterable {
        let id: UUID = UUID()
        let symbolName: String
        static let allCases: Array<LoanModel.Status> = [.upcoming, .current, .finished]
        static let unknown: Status = Status(symbolName: "questionmark.circle")
        static let new: Status = Status(symbolName: "play.circle")
        static let upcoming: Status = Status(symbolName: "calendar.circle")
        static let current: Status = Status(symbolName: "hourglass.circle")
        static let finished: Status = Status(symbolName: "stop.circle")
    }
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
        reminder: Date(),
        reminderActive: false,
        returned: false,
        status: LoanModel.Status.unknown,
        itemId: UUID(),
        borrowerId: UUID()
    )
}
