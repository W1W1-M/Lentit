//
//  LoanModel.swift
//  Lentit
//
//  Created by William Mead on 17/01/2022.
//

import Foundation
/// Data model for a item loan
class LoanModel: ObservableObject, Identifiable {
    // MARK: - Variables
    @Published var id: UUID
    @Published var lendDate: Date
    @Published var lendTime: TimeInterval
    @Published var lendExpiry: Date
    @Published var reminder: Date
    @Published var justAdded: Bool
    @Published var itemId: UUID
    @Published var borrowerId: UUID
    // MARK: - Init
    init(
        lendDate: Date,
        lendTime: TimeInterval,
        lendExpiry: Date,
        reminder: Date,
        justAdded: Bool,
        itemId: UUID,
        borrowerId: UUID
    ) {
        self.id = UUID()
        self.lendDate = lendDate
        self.lendTime = lendTime
        self.lendExpiry = lendExpiry
        self.reminder = reminder    
        self.justAdded = justAdded
        self.itemId = itemId
        self.borrowerId = borrowerId
    }
    // MARK: - Functions
}
