//
//  ItemModel.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Data model for lent item
class ItemModel: ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Variables
    let id: UUID
    var name: String
    var description: String
    var value: Int
    var category: ItemCategoryModel
    var status: ItemModel.Status
    var loanIds: [UUID]
// MARK: - Init
    init(
        name: String,
        description: String,
        value: Int,
        category: ItemCategoryModel,
        status: ItemModel.Status,
        loanIds: [UUID]
    ) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.value = value
        self.category = category
        self.status = status
        self.loanIds = loanIds
    }
// MARK: - Functions
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ItemModel {
    /// Predefined loan status
    struct Status: Equatable, CaseIterable {
        let id: UUID = UUID()
        let symbolName: String
        static let allCases: Array<ItemModel.Status> = [new, available, unavailable]
        static let unknown: Status = Status(symbolName: "questionmark.circle")
        static let new: Status = Status(symbolName: "play.circle")
        static let available: Status = Status(symbolName: "checkmark.circle")
        static let unavailable: Status = Status(symbolName: "xmark.circle")
    }
}

extension ItemModel {
    static var defaultData: ItemModel = ItemModel(
        name: "Unknown item",
        description: "Unknown description",
        value: 100,
        category: ItemCategories.categories[4],
        status: ItemModel.Status.unknown,
        loanIds: [UUID()]
    )
}
