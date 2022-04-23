//
//  ItemVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Item view model
class ItemVM: ViewModel, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    private(set) var item: ItemModel
    private(set) var loanIds: Set<UUID>
    @Published var name: String {
        didSet {
            item.name = self.name
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
    @Published var loanCount: Int
// MARK: - Init & deinit
    override init() {
        print("ItemVM init ...")
        self.item = ItemModel.defaultItemData
        self.loanIds = ItemModel.defaultItemData.loanIds
        self.name = ItemModel.defaultItemData.name
        self.notes = ItemModel.defaultItemData.notes
        self.value = ItemModel.defaultItemData.value
        self.valueText = ""
        self.category = ItemModel.defaultItemData.category
        self.loanCount = 0
        super.init()
        //
        self.loanCount = countItemLoans()
    }
    deinit {
        print("... deinit ItemVM \(id)")
    }
// MARK: - Methods
    func setVM(from item: ItemModel) {
        self.model = item
        self.item = item
        self.id = item.id
        self.loanIds = item.loanIds
        self.name = item.name
        self.notes = item.notes
        self.value = item.value
        self.valueText = setItemValueText(for: self.value)
        self.category = item.category
        self.status = item.status
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
