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
    @Published var value: Int {
        didSet{
            lentItem.value = value
        }
    }
    @Published var valueText: String {
        didSet{
            value = setLentItemValue(for: valueText)
        }
    }
    @Published var category: LentItemCategoryModel {
        didSet{
            lentItem.category = category
        }
    }
    @Published var borrowerId: UUID {
        didSet{
            lentItem.borrowerId = borrowerId
        }
    }
    @Published var lendDate: Date {
        didSet{
            lentItem.lendDate = lendDate
            // On change of lent item Date update lend date text, lend time, lend time text, lend expiry & lend expiry text
            lendDateText = setLentItemDateText(for: lentItem.lendDate)
            lendTime = setLentItemTime(from: lentItem.lendDate, to: lentItem.lendExpiry)
        }
    }
    @Published var lendDateText: String
    @Published var lendTime: TimeInterval {
        didSet{
            lentItem.lendTime = lendTime
            lendTimeText = setLentItemTimeText(for: lentItem.lendTime)
        }
    }
    @Published var lendTimeText: String
    @Published var lendExpiry: Date {
        didSet{
            lentItem.lendExpiry = lendExpiry
            lendExpiryText = setLentItemExpiryText(for: lentItem.lendExpiry)
            lendTime = setLentItemTime(from: lentItem.lendDate, to: lentItem.lendExpiry)
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
        self.lentItem = DataStoreModel.sampleLentItemData[0]
        self.id = UUID()
        self.nameText = "📦 Unknown"
        self.descriptionText = "Unknown item"
        self.value = 100
        self.valueText = "100€"
        self.category = LentItemCategories.categories[4]
        self.borrowerId = UUID()
        self.lendDate = Date()
        self.lendDateText = "20/02/2002"
        self.lendTime = 0
        self.lendTimeText = "0 days"
        self.lendExpiry = Date()
        self.lendExpiryText = "22/02/2002"
        self.justAdded = false
    }
// MARK: - Functions
    /// Function to set lent item view model
    /// - Parameter lentItem: Lent item model
    func setLentItemVM(for lentItem: LentItemModel) {
        self.lentItem = lentItem
        self.id = lentItem.id // Shared with lent item data object
        self.nameText = lentItem.name
        self.descriptionText = lentItem.description
        self.value = lentItem.value
        self.valueText = setLentItemValueText(for: lentItem.value)
        self.category = lentItem.category
        self.borrowerId = lentItem.borrowerId
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
    /// Function to get lent item lend time from lend date and lend expiry date
    /// - Parameters:
    ///   - lendDate: Item lend Date
    ///   - lendExpiry: Item lend expiry Date
    /// - Returns: Itel lend Time Interval
    func setLentItemTime(from lendDate: Date, to lendExpiry: Date) -> TimeInterval {
        let lendTime = lendExpiry.timeIntervalSince(lendDate)
        return lendTime
    }
    /// Function to set & format lent item value text
    /// - Parameter value: Lent item value Double
    /// - Returns: Lent item value String
    func setLentItemValueText(for itemValue: Int) -> String {
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
    /// Function to set lent item value
    /// - Parameter valueText: Lent item value String
    /// - Returns: Lent item value Double
    func setLentItemValue(for valueText: String) -> Int {
        let filteredValueText = filterLentItemValueText(for: valueText)
        if let value = Int(filteredValueText) {
            return value
        } else {
            let value: Int = 0
            return value
        }
    }
    /// Function to filter non numeric characters from value text user input
    /// - Parameter valueText: String of lent item value
    /// - Returns: String of lent item value containing only numeric characters
    func filterLentItemValueText(for valueText: String) -> String {
        let filteredValueText = valueText.filter("1234567890".contains)
        return filteredValueText
    }
}
