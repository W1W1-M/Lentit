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
    var loanExpiry: Date
    var reminder: Date
    var returned: Bool
    var status: LoanStatusModel
    var itemId: UUID
    var borrowerId: UUID
    // MARK: - Init
    init(
        id: UUID,
        loanDate: Date,
        loanTime: TimeInterval,
        loanExpiry: Date,
        reminder: Date,
        returned: Bool,
        status: LoanStatusModel,
        itemId: UUID,
        borrowerId: UUID
    ) {
        self.id = id
        self.loanDate = loanDate
        self.loanTime = loanTime
        self.loanExpiry = loanExpiry
        self.reminder = reminder
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
