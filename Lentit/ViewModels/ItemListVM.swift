//
//  ItemListVM.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import Foundation

/// Item list view model
class ItemListVM: ObservableObject {
    // MARK: - Variables
    @Published var itemsCount: Int
    @Published var newItemPresented: Bool
    @Published var newItemId: UUID
    @Published var newItemName: String
    @Published var newItemCategory: ItemModel.Category
    // MARK: - Init
    init() {
        self.itemsCount = 0
        self.newItemPresented = false
        self.newItemId = UUID()
        self.newItemName = ""
        self.newItemCategory = ItemModel.Category.other
    }
    // MARK: - Functions
    func setItemsCount(for itemVMs: [ItemVM]) {
        self.itemsCount = itemVMs.count
    }
    func showNewItem() {
        resetNewItem()
        self.newItemPresented = true
    }
    func hideNewItem() {
        resetNewItem()
        self.newItemPresented = false
    }
    func resetNewItem() {
        self.newItemId = UUID()
        self.newItemName = ""
        self.newItemCategory = ItemModel.Category.other
    }
}
