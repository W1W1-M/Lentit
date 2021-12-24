//
//  LentItemModel.swift
//  LendingLogbook
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
/// Data model for a lended item
class LentItemModel: ObservableObject, Identifiable {
// MARK: - Variables
    var id: UUID
    @Published var name: String
    @Published var description: String
    @Published var value: Double
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
    ///   - value: Double
    ///   - category: LentItemCategoryModel
    ///   - borrower: String
    ///   - lendDate: Date
    ///   - lendTime: TimeInterval
    init(
        id: UUID,
        name: String,
        description: String,
        value: Double,
        category: LentItemCategoryModel,
        borrower: String,
        lendDate: Date,
        lendTime: TimeInterval,
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
        self.lendExpiry = Date(timeInterval: lendTime, since: lendDate)
        self.justAdded = justAdded
    }
}
