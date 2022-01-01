//
//  LentItemModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
/// Data model for a lended item
class LentItemModel: ObservableObject, Identifiable, Equatable {
// MARK: - Variables
    var id: UUID
    @Published var name: String
    @Published var description: String
    @Published var value: Int
    @Published var category: LentItemCategoryModel
    @Published var borrower: String
    @Published var lendDate: Date
    @Published var lendTime: TimeInterval
    @Published var lendExpiry: Date
    @Published var justAdded: Bool
// MARK: - Init
    /// Custom initialization
    /// - Parameters:
    ///   - id: UUID
    ///   - name: String
    ///   - description: String
    ///   - value: Int
    ///   - category: LentItemCategoryModel
    ///   - borrower: String
    ///   - lendDate: Date
    ///   - lendTime: TimeInterval
    ///   - lendExpiry: Date
    ///   - justAdded: Bool
    init(
        id: UUID,
        name: String,
        description: String,
        value: Int,
        category: LentItemCategoryModel,
        borrower: String,
        lendDate: Date,
        lendTime: TimeInterval,
        lendExpiry: Date,
        justAdded: Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.value = value
        self.category = category
        self.borrower = borrower
        self.lendDate = lendDate
        self.lendTime = lendTime
        self.lendExpiry = lendExpiry
        self.justAdded = justAdded
    }
// MARK: - Functions
    static func == (lhs: LentItemModel, rhs: LentItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}
