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
    var notes: String
    var value: Int
    var category: ItemModel.Category
    var status: ItemModel.Status
    var loanIds: Set<UUID>
// MARK: - Init & deinit
    init(
        name: String,
        notes: String,
        value: Int,
        category: ItemModel.Category,
        status: ItemModel.Status,
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
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    func addLoanId(with loanId: UUID) {
        self.loanIds.insert(loanId)
    }
    func removeLoanId(with loanId: UUID) {
        self.loanIds.remove(loanId)
    }
}

extension ItemModel {
    /// Predefined item status
    struct Status: Identifiable, Equatable, CaseIterable {
        // Properties
        let id: UUID = UUID()
        let symbolName: String
        static let all: Status = Status(symbolName: "infinity.circle")
        static let unknown: Status = Status(symbolName: "questionmark.circle")
        static let new: Status = Status(symbolName: "play.circle")
        static let available: Status = Status(symbolName: "checkmark.circle")
        static let unavailable: Status = Status(symbolName: "xmark.circle")
        static let allCases: Array<ItemModel.Status> = [all, available, unavailable]
    }
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
    static var defaultData: ItemModel = ItemModel(
        name: "Unknown item",
        notes: "Unknown description",
        value: 100,
        category: ItemModel.Category.other,
        status: ItemModel.Status.unknown,
        loanIds: [UUID()]
    )
}
