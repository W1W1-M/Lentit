//
//  LoanSortingOrderModel.swift
//  Lentit
//
//  Created by William Mead on 20/02/2022.
//

import Foundation
/// Custom type for lent item sort orders
struct LoanSortingOrderModel: Equatable {
    let id: UUID
    let name: String
    /// Custom initialization
    /// - Parameter name: String to describe sorting order
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
/// Predefined lent item sort orders
struct LoanSortingOrders {
    static var byItemName: LoanSortingOrderModel = LoanSortingOrderModel(name: "by Item Name")
    static var byBorrowerName: LoanSortingOrderModel = LoanSortingOrderModel(name: "by Borrower Name")
}
