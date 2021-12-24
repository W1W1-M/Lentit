//
//  LentItemCategoryModel.swift
//  LendingLogbook
//
//  Created by William Mead on 24/12/2021.
//

import Foundation

/// <#Description#>
struct LentItemCategoryModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    /// <#Description#>
    /// - Parameter name: <#name description#>
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

/// <#Description#>
struct LentItemCategories {
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
