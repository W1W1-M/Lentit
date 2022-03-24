//
//  ItemModel.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Data model for lent item
class ItemModel: ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Properties
    let id: UUID
    var name: String
    var description: String
    var value: Int
    var category: ItemModel.Category
    var status: ItemModel.Status
    var loanIds: [UUID]
// MARK: - Init
    init(
        name: String,
        description: String,
        value: Int,
        category: ItemModel.Category,
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
// MARK: - Methods
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ItemModel {
    /// Predefined item status
    struct Status: Identifiable, Equatable, CaseIterable {
        // Properties
        let id: UUID = UUID()
        let symbolName: String
        static let allCases: Array<ItemModel.Status> = [new, available, unavailable]
        static let unknown: Status = Status(symbolName: "questionmark.circle")
        static let new: Status = Status(symbolName: "play.circle")
        static let available: Status = Status(symbolName: "checkmark.circle")
        static let unavailable: Status = Status(symbolName: "xmark.circle")
    }
    /// Predefined  item categories
    struct Category: Identifiable, Equatable, Hashable, CaseIterable {
        // Properties
        let id: UUID = UUID()
        let emoji: String
        static let all: Category = Category(emoji: "🗂")
        static let books: Category = Category(emoji: "📚")
        static let cars: Category = Category(emoji: "🚗")
        static let clothes: Category = Category(emoji: "👔")
        static let films: Category = Category(emoji: "🎞")
        static let other: Category = Category(emoji: "📦")
        static let pens: Category = Category(emoji: "🖊")
        static let toys: Category = Category(emoji: "🧸")
        static let allCases: Array<ItemModel.Category> = [books, cars, clothes, films, other, pens, toys]
        // Methods
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
}

extension ItemModel {
    static var defaultData: ItemModel = ItemModel(
        name: "Unknown item",
        description: "Unknown description",
        value: 100,
        category: ItemModel.Category.other,
        status: ItemModel.Status.unknown,
        loanIds: [UUID()]
    )
}
