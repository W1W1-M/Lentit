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
    /// Custom initialization
    /// - Parameter name: String to describe lent item category
    init(emoji: String) {
        self.id = UUID()
        self.emoji = emoji
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
    static let all: ItemCategoryModel = ItemCategoryModel(emoji: "🗂")
    static let books: ItemCategoryModel = ItemCategoryModel(emoji: "📚")
    static let cars: ItemCategoryModel = ItemCategoryModel(emoji: "🚗")
    static let clothes: ItemCategoryModel = ItemCategoryModel(emoji: "👔")
    static let films: ItemCategoryModel = ItemCategoryModel(emoji: "🎞")
    static let other: ItemCategoryModel = ItemCategoryModel(emoji: "📦")
    static let pens: ItemCategoryModel = ItemCategoryModel(emoji: "🖊")
    static let toys: ItemCategoryModel = ItemCategoryModel(emoji: "🧸")
    static let categories: Array<ItemCategoryModel> = [books, cars, clothes, films, other, pens, toys]
}
