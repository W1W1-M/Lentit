//
//  LentItemStoreModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
/// Store for lent items
class LentItemStoreModel: ObservableObject {
    @Published var storedItems: [LentItemModel]
    init() {
        self.storedItems = []
    }
}

extension LentItemStoreModel {
    static var sampleData: [LentItemModel] = [
        LentItemModel(
            id: UUID(),
            name: "💿 IronMan bluray",
            description: "Film about some guy in an armored suit",
            value: 10.00,
            category: LentItemCategories.categories[3],
            borrower: "Sarah",
            lendDate: Date(),
            lendTime: 600000.0,
            justAdded: false
        ),
        LentItemModel(
            id: UUID(),
            name: "🛡 Captain America shield",
            description: "An old rusty medievil shield",
            value: 250.00,
            category: LentItemCategories.categories[2],
            borrower: "Anthony",
            lendDate: Date(),
            lendTime: 1200000.0,
            justAdded: false
        ),
        LentItemModel(
            id: UUID(),
            name: "🕷 Spiderman lego",
            description: "Red lego bricks",
            value: 30.00,
            category: LentItemCategories.categories[6],
            borrower: "Charly",
            lendDate: Date(),
            lendTime: 1800000.0,
            justAdded: false
        )
    ]
}
