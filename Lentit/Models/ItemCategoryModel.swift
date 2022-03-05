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
    func getSingularCategoryName(name: String) -> String {
        var singularName: String = ""
        if(name.hasSuffix("s")) {
            singularName = String(name.prefix(upTo: name.index(before: name.endIndex)))
        } else if(name == "Other") {
            singularName = name
        } else if(name == "All") {
            singularName = name
        } else {
            singularName = ""
        }
        return singularName
    }
}

/// Predefined lent item categories
struct ItemCategories {
    static let all: ItemCategoryModel = ItemCategoryModel(emoji: "🗂", name: "All")
    static let books: ItemCategoryModel = ItemCategoryModel(emoji: "📚", name: "Books")
    static let cars: ItemCategoryModel = ItemCategoryModel(emoji: "🚗", name: "Cars")
    static let clothes: ItemCategoryModel = ItemCategoryModel(emoji: "👔", name: "Clothes")
    static let films: ItemCategoryModel = ItemCategoryModel(emoji: "🎞", name: "Films")
    static let other: ItemCategoryModel = ItemCategoryModel(emoji: "📦", name: "Other")
    static let pens: ItemCategoryModel = ItemCategoryModel(emoji: "🖊", name: "Pens")
    static let toys: ItemCategoryModel = ItemCategoryModel(emoji: "🧸", name: "Toys")
    static let categories: Array<ItemCategoryModel> = [books, cars, clothes, films, other, pens, toys]
}
