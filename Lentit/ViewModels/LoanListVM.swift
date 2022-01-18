//
//  LoanListVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
// MARK: - Classes
/// Loan list view model
class LoanListVM: ObservableObject {
    // MARK: - Variables
    @Published var loansCountText: String
    @Published var activeCategory: ItemCategoryModel
    @Published var activeSort: SortingOrder
    var loanVMs: Array<LoanVM>
    // MARK: - Init
    init(loanVMs: [LoanVM]) {
        self.loansCountText = ""
        self.activeCategory = ItemCategories.all
        self.activeSort = SortingOrders.byItemName
        self.loanVMs = loanVMs
    }
    // MARK: - Functions
    /// <#Description#>
    /// - Parameter loansVMs: <#loansVMs description#>
    /// - Returns: <#description#>
    func setLoansCount(for loansVMs: [LoanVM]) -> String {
        let loansCountText = "\(loansVMs.count)"
        return loansCountText
    }
}
// MARK: - Structs
struct SortingOrders {
    static var byItemName: SortingOrder = SortingOrder(name: "byItemName")
    static var byLendExpiry: SortingOrder = SortingOrder(name: "byLendExpiry")
}

struct SortingOrder: Equatable {
    let id: UUID
    let name: String
    /// Custom initialization
    /// - Parameter name: String to describe sorting order
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
