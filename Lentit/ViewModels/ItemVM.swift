//
//  ItemVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Item view model
class ItemVM: ObservableObject, Identifiable {
    // MARK: - Variables
    var item: ItemModel
    @Published var id: UUID
    @Published var nameText: String
    @Published var category: ItemCategoryModel
    // MARK: - Init
    init() {
        self.item = DataStoreModel.sampleItemData[0]
        self.id = UUID()
        self.nameText = "Unknown item"
        self.category = ItemCategories.categories[4]
    }
    // MARK: - Functions
    func setItemVM(from itemModel: ItemModel) {
        self.item = itemModel
        self.id = itemModel.id
        self.nameText = itemModel.name
        self.category = itemModel.category
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
