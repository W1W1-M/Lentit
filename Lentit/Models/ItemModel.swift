//
//  ItemModel.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Data model for lent item
final class ItemModel: ModelProtocol, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    internal var id: UUID
    internal var name: String
    internal var notes: String
    internal var value: Int
    internal var category: ItemModel.Category
    internal var status: StatusModel
    internal var loanIds: Set<UUID>
// MARK: - Init & deinit
    init(
        name: String,
        notes: String,
        value: Int,
        category: ItemModel.Category,
        status: StatusModel,
        loanIds: Set<UUID>
    ) {
        print("ItemModel init ...")
        self.id = UUID()
        self.name = name
        self.notes = notes
        self.value = value
        self.category = category
        self.status = status
        self.loanIds = loanIds
    }
    deinit {
        print("... deinit ItemModel")
    }
// MARK: - Methods
    func addLoanId(with loanId: UUID) {
        self.loanIds.insert(loanId)
    }
    func removeLoanId(with loanId: UUID) {
        self.loanIds.remove(loanId)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension ItemModel {
    /// Predefined item categories
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
    /// Predefined item sorting orders
    struct SortingOrder: Identifiable, Equatable, Hashable, CaseIterable {
        // Properties
        let id: UUID = UUID()
        static let byName: SortingOrder = SortingOrder()
        static let allCases: [ItemModel.SortingOrder] = [byName]
    }
}

extension ItemModel {
    static var defaultItemData: ItemModel = ItemModel(
        name: "Unknown item",
        notes: "Unknown description",
        value: 100,
        category: ItemModel.Category.other,
        status: StatusModel.unknown,
        loanIds: [UUID()]
    )
}
