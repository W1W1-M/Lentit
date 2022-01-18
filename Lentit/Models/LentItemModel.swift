//
//  LentItemModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
// MARK: - Classes
/// Data model for a lended item
class LentItemModel: ObservableObject, Identifiable, Equatable {
// MARK: - Variables
    var id: UUID
    @Published var name: String
    @Published var description: String
    @Published var value: Int
    @Published var category: ItemCategoryModel
    @Published var loanIds: [UUID]
    @Published var borrowerId: UUID
    @Published var lendDate: Date
    @Published var lendTime: TimeInterval
    @Published var lendExpiry: Date
    @Published var returnedSold: Bool
    @Published var justAdded: Bool
// MARK: - Init
    /// Custom initialization
    /// - Parameters:
    ///   - name: String
    ///   - description: String
    ///   - value: Int
    ///   - category: ItemCategoryModel
    ///   - lendDate: Date
    ///   - lendTime: TimeInterval
    ///   - lendExpiry: Date
    ///   - returnedSold: <#returned description#>
    ///   - justAdded: Bool
    ///   - borrowerId: <#borrowerID description#>
    init(
        name: String,
        description: String,
        value: Int,
        category: ItemCategoryModel,
        lendDate: Date,
        lendTime: TimeInterval,
        lendExpiry: Date,
        returnedSold: Bool,
        justAdded: Bool,
        borrowerId: UUID
    ) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.value = value
        self.category = category
        self.lendDate = lendDate
        self.lendTime = lendTime
        self.lendExpiry = lendExpiry
        self.returnedSold = returnedSold
        self.justAdded = justAdded
        self.loanIds = []
        self.borrowerId = borrowerId
    }
// MARK: - Functions
    static func == (lhs: LentItemModel, rhs: LentItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}
