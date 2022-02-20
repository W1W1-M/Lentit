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
    let emoji: String
    let name: String
    let fullName: String
    /// Custom initialization
    /// - Parameter name: String to describe lent item category
    init(emoji: String, name: String) {
        self.id = UUID()
        self.emoji = emoji
        self.name = name
        self.fullName = "\(emoji) \(name)"
    }
}

/// Predefined lent item categories
struct ItemCategories {
    static let all: ItemCategoryModel = ItemCategoryModel(emoji: "🗂", name: "All")
    static let categories: [ItemCategoryModel] = [
        ItemCategoryModel(emoji: "📚", name: "Books"),
        ItemCategoryModel(emoji: "🚗", name: "Cars"),
        ItemCategoryModel(emoji: "👔", name: "Clothes"),
        ItemCategoryModel(emoji: "🎞", name: "Films"),
        ItemCategoryModel(emoji: "📦", name: "Other"),
        ItemCategoryModel(emoji: "🖊", name: "Pens"),
        ItemCategoryModel(emoji: "🧸", name: "Toys")
    ]
}
