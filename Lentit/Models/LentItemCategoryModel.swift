//
//  LentItemCategoryModel.swift
//  Lentit
//
//  Created by William Mead on 24/12/2021.
//

import Foundation

/// Custom type for lent item category
struct LentItemCategoryModel: Identifiable, Hashable {
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
struct LentItemCategories {
    static let all: LentItemCategoryModel = LentItemCategoryModel(name: "🗂 All")
    static let categories: [LentItemCategoryModel] = [
        LentItemCategoryModel(name: "📚 Books"),
        LentItemCategoryModel(name: "🚗 Cars"),
        LentItemCategoryModel(name: "👔 Clothes"),
        LentItemCategoryModel(name: "🎞 Films"),
        LentItemCategoryModel(name: "📦 Other"),
        LentItemCategoryModel(name: "🖊 Pens"),
        LentItemCategoryModel(name: "🧸 Toys")
    ]
}
