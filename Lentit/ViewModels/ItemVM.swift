//
//  ItemVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Item view model
final class ItemVM: ViewModelProtocol, ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Properties
    typealias ModelType = ItemModel
    internal var model: ModelType
    internal var id: UUID
    internal var loanIds: Set<UUID>
    @Published var name: String {
        didSet {
            model.name = self.name
        }
    }
    @Published var notes: String {
        didSet {
            model.notes = self.notes
        }
    }
    @Published var value: Int
    @Published var valueText: String {
        didSet {
            model.value = setItemValue(for: self.valueText)
        }
    }
    @Published var status: StatusModel {
        didSet {
            self.model.status = status
        }
    }
    @Published var category: ItemModel.Category {
        didSet {
            model.category = self.category
        }
    }
    @Published var loanCount: Int
// MARK: - Init & deinit
    init() {
        print("ItemVM init ...")
        self.model = ItemModel.defaultItemData
        self.id = ItemModel.defaultItemData.id
        self.loanIds = ItemModel.defaultItemData.loanIds
        self.name = ItemModel.defaultItemData.name
        self.notes = ItemModel.defaultItemData.notes
        self.value = ItemModel.defaultItemData.value
        self.valueText = ""
        self.status = ItemModel.defaultItemData.status
        self.category = ItemModel.defaultItemData.category
        self.loanCount = 0
    }
    deinit {
        print("... deinit ItemVM \(id)")
    }
// MARK: - Methods
    func setVM(from model: ModelType) {
        print("setVM ...")
        self.model = model
        self.id = model.id
        self.loanIds = model.loanIds
        self.name = model.name
        self.notes = model.notes
        self.value = model.value
        self.valueText = setItemValueText(for: self.value)
        self.category = model.category
        self.status = model.status
        self.loanCount = countItemLoans()
        print("... setVM Item \(id)")
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
        self.model.loanIds = self.loanIds
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ItemVM, rhs: ItemVM) -> Bool {
        lhs.id == rhs.id
    }
}
