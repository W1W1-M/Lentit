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
    var id: UUID
    var name: String
    var description: String
    var value: Int
    var category: ItemCategoryModel
    var justAdded: Bool
    var loanIds: [UUID]
// MARK: - Init
    init(
        id: UUID,
        name: String,
        description: String,
        value: Int,
        category: ItemCategoryModel,
        justAdded: Bool,
        loanIds: [UUID]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.value = value
        self.category = category
        self.justAdded = justAdded
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
