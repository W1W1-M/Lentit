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
    var id: UUID
    var loanDate: Date
    var loanTime: TimeInterval
    var loanExpiry: Date {
        loanDate.addingTimeInterval(loanTime)
    }
    var reminder: Date
    var reminderActive: Bool
    var returned: Bool
    var status: LoanStatusModel
    var itemId: UUID
    var borrowerId: UUID
    // MARK: - Init
    init(
        id: UUID,
        loanDate: Date,
        loanTime: TimeInterval,
        reminder: Date,
        reminderActive: Bool,
        returned: Bool,
        status: LoanStatusModel,
        itemId: UUID,
        borrowerId: UUID
    ) {
        self.id = id
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
    static var defaultData: LoanModel = LoanModel(
        id: UUID(),
        loanDate: Date(),
        loanTime: 100000.0,
        reminder: Date(),
        reminderActive: false,
        returned: false,
        status: LoanStatus.unknown,
        itemId: UUID(),
        borrowerId: UUID()
    )
}
