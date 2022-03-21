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
    var status: ItemStatusModel
    var loanIds: [UUID]
// MARK: - Init
    init(
        name: String,
        description: String,
        value: Int,
        category: ItemCategoryModel,
        status: ItemStatusModel,
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
    static var defaultData: ItemModel = ItemModel(
        name: "Unknown item",
        description: "Unknown description",
        value: 100,
        category: ItemCategories.categories[4],
        status: ItemStatus.unknown,
        loanIds: [UUID()]
    )
}
