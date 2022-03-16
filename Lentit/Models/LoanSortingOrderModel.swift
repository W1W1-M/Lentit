//
//  LoanSortingOrderModel.swift
//  Lentit
//
//  Created by William Mead on 20/02/2022.
//

import Foundation
/// Custom type for loan sort orders
struct LoanSortingOrderModel: Identifiable, Hashable, Equatable {
    let id: UUID
    /// Custom initialization
    init() {
        self.id = UUID()
    }
}
/// Predefined loan sort orders
struct LoanSortingOrders {
    static let byItemName: LoanSortingOrderModel = LoanSortingOrderModel()
    static let byBorrowerName: LoanSortingOrderModel = LoanSortingOrderModel()
    static let byLoanDate: LoanSortingOrderModel = LoanSortingOrderModel()
    static let sortingOrders: Array<LoanSortingOrderModel> = [byItemName, byBorrowerName, byLoanDate]
}
