//
//  LentItemVM.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//
import Foundation
/// Lent item view model
class LentItemVM: ObservableObject, Identifiable {
// MARK: - Variables
    @Published var lentItem: LentItemModel
    @Published var id: UUID
    @Published var nameText: String {
        didSet{
            lentItem.name = nameText
        }
    }
    @Published var descriptionText: String {
        didSet{
            lentItem.description = descriptionText
        }
    }
    @Published var valueText: String {
        didSet{
            lentItem.value = setLentItemValue(for: valueText)
        }
    }
    @Published var category: LentItemCategoryModel {
        didSet{
            lentItem.category = category
        }
    }
    @Published var borrowerText: String {
        didSet{
            lentItem.borrower = borrowerText
        }
    }
    @Published var lendDate: Date {
        didSet{
            lentItem.lendDate = lendDate
            // On change of lent item Date update lend date text, lend time, lend time text, lend expiry & lend expiry text
            lendDateText = setLentItemDateText(for: lentItem.lendDate)
            lentItem.lendTime = setLentItemTime(from: lentItem.lendDate, to: lentItem.lendExpiry)
            lendTimeText = setLentItemTimeText(for: lentItem.lendTime)
        }
    }
    @Published var lendDateText: String
    @Published var lendTime: TimeInterval
    @Published var lendTimeText: String
    @Published var lendExpiry: Date {
        didSet{
            lentItem.lendExpiry = lendExpiry
            lendExpiryText = setLentItemExpiryText(for: lentItem.lendExpiry)
            lentItem.lendTime = setLentItemTime(from: lentItem.lendDate, to: lentItem.lendExpiry)
            lendTimeText = setLentItemTimeText(for: lentItem.lendTime)
        }
    }
    @Published var lendExpiryText: String
    @Published var justAdded: Bool {
        didSet {
            lentItem.justAdded = justAdded
        }
    }
// MARK: - Init
    /// Custom init to initialize view model with default data
    init() {
        self.lentItem = LentItemStoreModel.sampleData[0]
        self.id = UUID()
        self.nameText = "📦 Unknown"
        self.descriptionText = "Unknown item"
        self.valueText = "0€"
        self.category = LentItemCategories.categories[4]
        self.borrowerText = "Unknown borrower"
        self.lendDate = Date()
        self.lendDateText = "20/02/2002"
        self.lendTime = 0
        self.lendTimeText = "2 days"
        self.lendExpiry = Date()
        self.lendExpiryText = "22/02/2002"
        self.justAdded = false
    }
// MARK: - Functions
    /// Function to set lent item view model
    /// - Parameter lentItem: Lent item model
    func setLentItemVM(for lentItem: LentItemModel) {
        self.lentItem = lentItem
        self.id = lentItem.id
        self.nameText = lentItem.name
        self.descriptionText = lentItem.description
        self.valueText = setLentItemValueText(for: lentItem.value)
        self.category = lentItem.category
        self.borrowerText = lentItem.borrower
        self.lendDate = lentItem.lendDate
        self.lendDateText = setLentItemDateText(for: lentItem.lendDate)
        self.lendTime = lentItem.lendTime
        self.lendTimeText = setLentItemTimeText(for: lentItem.lendTime)
        self.lendExpiry = lentItem.lendExpiry
        self.lendExpiryText = setLentItemExpiryText(for: lentItem.lendExpiry)
        self.justAdded = lentItem.justAdded
    }
    /// Function to set item lend date text
    /// - Parameter lendDate: Item lend Date
    /// - Returns: Item lend date String
    func setLentItemDateText(for lendDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let lendDateText: String = dateFormat.string(from: lendDate)
        return lendDateText
    }
    /// Function to set item lend expiry date text
    /// - Parameter lendExpiry: Item lend expiry Date
    /// - Returns: Item lend expiry date String
    func setLentItemExpiryText(for lendExpiry: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let lendExpiryText: String = dateFormat.string(from: lendExpiry)
        return lendExpiryText
    }
    /// Function to set item lend expiry date
    /// - Parameters:
    ///   - lendDate: Item lend Date
    ///   - lendTime: Item lend TimeInterval
    /// - Returns: Item lend expiry Date
    func setLentItemExpiry(from lendDate: Date, lendTime: TimeInterval) -> Date {
        let lendExpiry: Date = Date(timeInterval: lendTime, since: lendDate)
        return lendExpiry
    }
    /// Function to set item lend time text
    /// - Parameter lendTime: Item lend TimeInterval
    /// - Returns: Item lend time String
    func setLentItemTimeText(for lendTime: TimeInterval) -> String {
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .short
        timeFormat.allowedUnits = [.day, .month, .year]
        if let lendTime = timeFormat.string(from: lendTime) {
            let lendTimeText = lendTime
            return lendTimeText
        } else {
            let lendTimeText = ""
            return lendTimeText
        }
    }
    /// <#Description#>
    /// - Parameters:
    ///   - lendDate: <#lendDate description#>
    ///   - lendExpiry: <#lendExpiry description#>
    /// - Returns: <#description#>
    func setLentItemTime(from lendDate: Date, to lendExpiry: Date) -> TimeInterval {
        let lendTime = lendDate.timeIntervalSince(lendExpiry)
        return lendTime
    }
    /// Function to set lent item value text
    /// - Parameter value: Lent item value Double
    /// - Returns: Lent item value String
    func setLentItemValueText(for itemValue: Double) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.locale = .current
        numberFormat.numberStyle = .currency
        if let value = numberFormat.string(from: NSNumber(value: itemValue)) {
            let valueText = value
            return valueText
        } else {
            let valueText = "?"
            return valueText
        }
    }
    /// Function to set lent item value
    /// - Parameter valueText: Lent item value String
    /// - Returns: Lent item value Double
    func setLentItemValue(for valueText: String) -> Double {
        if let value = Double(valueText) {
            return value
        } else {
            let value: Double = 0.0
            return value
        }
    }
}
