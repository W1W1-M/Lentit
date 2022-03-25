//
//  ItemVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Item view model
class ItemVM: ObservableObject, Identifiable, Equatable, Hashable {
    // MARK: - Variables
    private(set) var item: ItemModel
    private(set) var id: UUID
    private(set) var loanIds: Set<UUID>
    @Published var nameText: String {
        didSet {
            item.name = self.nameText
        }
    }
    @Published var notes: String {
        didSet {
            item.notes = self.notes
        }
    }
    @Published var value: Int
    @Published var valueText: String {
        didSet {
            item.value = setItemValue(for: self.valueText)
        }
    }
    @Published var category: ItemModel.Category {
        didSet {
            item.category = self.category
        }
    }
    @Published var status: ItemModel.Status{
        didSet{
            item.status = self.status
        }
    }
    @Published var loanCount: Int
    // MARK: - Init
    init() {
        self.item = ItemModel.defaultData
        self.id = ItemModel.defaultData.id
        self.loanIds = ItemModel.defaultData.loanIds
        self.nameText = ItemModel.defaultData.name
        self.notes = ItemModel.defaultData.notes
        self.value = ItemModel.defaultData.value
        self.valueText = ""
        self.category = ItemModel.defaultData.category
        self.status = ItemModel.defaultData.status
        self.loanCount = 0
        //
        self.loanCount = countItemLoans()
    }
    // MARK: - Functions
    func setItemVM(from itemModel: ItemModel) {
        self.item = itemModel
        self.id = itemModel.id
        self.loanIds = itemModel.loanIds
        self.nameText = itemModel.name
        self.notes = itemModel.notes
        self.value = itemModel.value
        self.valueText = setItemValueText(for: self.value)
        self.category = itemModel.category
        self.status = itemModel.status
        self.loanCount = countItemLoans()
    }
    func countItemLoans() -> Int {
        loanIds.count
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
    func setItemValueText(for itemValueText: String) -> String {
        let itemValue = setItemValue(for: itemValueText)
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
    func updateItemLoans(with loanVMId: UUID) {
        self.loanIds.insert(loanVMId)
        self.item.loanIds = self.loanIds
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ItemVM, rhs: ItemVM) -> Bool {
        lhs.id == rhs.id
    }
}
