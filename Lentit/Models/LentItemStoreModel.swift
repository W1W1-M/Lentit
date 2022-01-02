//
//  LentItemStoreModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
/// Store for lent items
class LentItemStoreModel: ObservableObject {
// MARK: - Variables
    @Published var storedItems: [LentItemModel]
    init() {
        self.storedItems = LentItemStoreModel.sampleData
    }
    // MARK: - Functions
    /// <#Description#>
    /// - Parameter lentItem: <#lentItem description#>
    func addLentItem(newItem lentItem: LentItemModel) {
        storedItems.append(lentItem)
    }
    /// <#Description#>
    /// - Parameter lentItem: <#lentItem description#>
    func removeLentItem(oldItem lentItem: LentItemModel) {
        if let oldIndex = storedItems.firstIndex(of: lentItem) {
            storedItems.remove(at: oldIndex)
        }
    }
}

extension LentItemStoreModel {
    static var sampleData: [LentItemModel] = [
        LentItemModel(
            id: UUID(),
            name: "💿 IronMan bluray",
            description: "Film about some guy in an armored suit",
            value: 10,
            category: LentItemCategories.categories[3],
            borrower: "Sarah",
            lendDate: Date(),
            lendTime: 600000.0,
            lendExpiry: Date(timeInterval: 600000.0, since: Date()),
            justAdded: false
        ),
        LentItemModel(
            id: UUID(),
            name: "🛡 Vibranium shield",
            description: "An old rusty medievil shield",
            value: 250,
            category: LentItemCategories.categories[2],
            borrower: "Anthony",
            lendDate: Date(timeIntervalSince1970: 600000.0),
            lendTime: 600000.0,
            lendExpiry: Date(timeInterval: 600000.0, since: Date(timeIntervalSince1970: 600000.0)),
            justAdded: false
        ),
        LentItemModel(
            id: UUID(),
            name: "🕷 Spiderman lego",
            description: "Red lego bricks",
            value: 30,
            category: LentItemCategories.categories[6],
            borrower: "Charly",
            lendDate: Date(),
            lendTime: 1800000.0,
            lendExpiry: Date(timeInterval: 1200000.0, since: Date()),
            justAdded: false
        )
    ]
}
