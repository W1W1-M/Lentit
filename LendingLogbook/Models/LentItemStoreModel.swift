//
//  LentItemStoreModel.swift
//  LendingLogbook
//
//  Created by William Mead on 20/12/2021.
//

import Foundation
import SwiftUI

class LentItemStoreModel: ObservableObject {
    @Published var storedItems: [LentItemModel]
    init(itemData: [LentItemModel]) {
        self.storedItems = itemData
    }
}

extension LentItemStoreModel {
    static var sampleData: [LentItemModel] = [
        LentItemModel(
            id: UUID(),
            name: "IronMan bluray",
            emoji: "💿",
            description: "Film about some guy in an armored suit",
            value: 10.00,
            category: "Films",
            borrower: "Sarah",
            lendDate: Date(),
            lendTime: 600000.0
        ),
        LentItemModel(
            id: UUID(),
            name: "Captain America shield",
            emoji: "🛡",
            description: "An old rusty medievil shield",
            value: 250.00,
            category: "Suits",
            borrower: "Anthony",
            lendDate: Date(),
            lendTime: 1200000.0
        ),
        LentItemModel(
            id: UUID(),
            name: "Spiderman lego",
            emoji: "🧸",
            description: "Red lego bricks",
            value: 30.00,
            category: "Toys",
            borrower: "Charly",
            lendDate: Date(),
            lendTime: 1800000.0
        )
    ]
}
