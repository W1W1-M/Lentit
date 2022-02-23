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
    @Published var itemsCountText: String
    @Published var newItemPresented: Bool
    @Published var newItemId: UUID
    @Published var newItemName: String
    @Published var newItemValue: Int
    @Published var newItemValueText: String{
        didSet {
            self.newItemValue = setItemValue(for: self.newItemValueText)
        }
    }
    @Published var newItemCategory: ItemCategoryModel
    // MARK: - Init
    init() {
        self.itemsCountText = "0"
        self.newItemPresented = false
        self.newItemId = UUID()
        self.newItemName = ""
        self.newItemValue = 0
        self.newItemValueText = "0€"
        self.newItemCategory = ItemCategories.categories[4]
    }
    // MARK: - Functions
    func setItemsCount(for itemVMs: [ItemVM]) {
        self.itemsCountText = "\(itemVMs.count)"
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
        self.newItemValue = 0
        self.newItemValueText = "0€"
        self.newItemCategory = ItemCategories.categories[4]
    }
    func setItemValueText(for itemValue: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.locale = .current
        numberFormat.numberStyle = .currency
        numberFormat.maximumFractionDigits = 0
        if let value = numberFormat.string(from: NSNumber(value: itemValue)) {
            let valueText = value
            return valueText
        } else {
            let valueText = "?"
            return valueText
        }
    }
    func setItemValue(for valueText: String) -> Int {
        let filteredValueText = filterItemValueText(for: valueText)
        if let value = Int(filteredValueText) {
            return value
        } else {
            let value: Int = 0
            return value
        }
    }
    func filterItemValueText(for valueText: String) -> String {
        let filteredValueText = valueText.filter("1234567890".contains)
        return filteredValueText
    }
}
