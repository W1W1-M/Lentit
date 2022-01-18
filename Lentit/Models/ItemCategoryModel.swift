//
//  ItemCategoryModel.swift
//  Lentit
//
//  Created by William Mead on 24/12/2021.
//

import Foundation

/// Custom type for lent item category
struct ItemCategoryModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    /// Custom initialization
    /// - Parameter name: String to describe lent item category
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

/// Predefined lent item categories
struct ItemCategories {
    static let all: ItemCategoryModel = ItemCategoryModel(name: "🗂 All")
    static let categories: [ItemCategoryModel] = [
        ItemCategoryModel(name: "📚 Books"),
        ItemCategoryModel(name: "🚗 Cars"),
        ItemCategoryModel(name: "👔 Clothes"),
        ItemCategoryModel(name: "🎞 Films"),
        ItemCategoryModel(name: "📦 Other"),
        ItemCategoryModel(name: "🖊 Pens"),
        ItemCategoryModel(name: "🧸 Toys")
    ]
}
