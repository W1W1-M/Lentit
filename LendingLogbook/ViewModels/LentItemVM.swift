//
//  LentItemVM.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//
import Foundation
/// Lent item view model class
class LentItemVM: ObservableObject, Identifiable {
// MARK: - Variables
    @Published var lentItem: LentItemModel
    @Published var id: UUID
    @Published var nameText: String {
        didSet{
            lentItem.name = nameText
        }
    }
    @Published var emojiText: String
    @Published var descriptionText: String {
        didSet{
            lentItem.description = descriptionText
        }
    }
    @Published var valueText: String
    @Published var categoryText: String {
        didSet{
            lentItem.category = categoryText
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
            // On change of lent item Date update lend date text, lend expiry & lend expiry text
            lendDateText = setLentItemDateText(for: lentItem.lendDate)
            lentItem.lendExpiry = setLentItemExpiry(from: lentItem.lendDate, lendTime: lentItem.lendTime)
            lendExpiryText = setLentItemExpiryText(for: lentItem.lendExpiry)
        }
    }
    @Published var lendDateText: String
    @Published var lendTimeText: String
    @Published var lendExpiryText: String
// MARK: - Init
    /// Custom init to initialize view model with default data
    init() {
        self.lentItem = LentItemStoreModel.sampleData[0]
        self.id = UUID()
        self.nameText = "Unknown name"
        self.emojiText = "🤨"
        self.descriptionText = "Unknown item"
        self.valueText = "0€"
        self.categoryText = "Unknown category"
        self.borrowerText = "Unknown borrower"
        self.lendDate = Date()
        self.lendDateText = "20/02/2002"
        self.lendTimeText = "2 days"
        self.lendExpiryText = "22/02/2002"
    }
// MARK: - Functions
    /// Function to set lent item view model
    /// - Parameter lentItem: Lent item model
    func setLentItemVM(for lentItem: LentItemModel) {
        self.lentItem = lentItem
        self.id = lentItem.id
        self.nameText = lentItem.name
        self.emojiText = lentItem.emoji
        self.descriptionText = lentItem.description
        //
        let numberFormat = NumberFormatter()
        numberFormat.locale = .current
        numberFormat.numberStyle = .currency
        if let value = numberFormat.string(from: NSNumber(value: lentItem.value)) {
            self.valueText = value
        } else {
            self.valueText = "?"
        }
        self.categoryText = lentItem.category
        self.borrowerText = lentItem.borrower
        self.lendDate = lentItem.lendDate
        self.lendDateText = setLentItemDateText(for: lentItem.lendDate)
        self.lendTimeText = setLentItemTimeText(for: lentItem.lendTime)
        self.lendExpiryText = setLentItemExpiryText(for: lentItem.lendExpiry)
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
}
