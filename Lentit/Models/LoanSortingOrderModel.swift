//
//  LoanSortingOrderModel.swift
//  Lentit
//
//  Created by William Mead on 20/02/2022.
//

import Foundation
/// Custom type for lent item sort orders
struct LoanSortingOrderModel: Identifiable, Hashable, Equatable {
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
    static let byItemName: LoanSortingOrderModel = LoanSortingOrderModel(name: "by Item")
    static let byBorrowerName: LoanSortingOrderModel = LoanSortingOrderModel(name: "by Borrower")
    static let sortingOrders: Array<LoanSortingOrderModel> = [byItemName, byBorrowerName]
}
