//
//  LentItemVM.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import Foundation

/// lent item view model class
class LentItemVM: ObservableObject, Identifiable {
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
    /// Custom init to initialize view model with default data
    /// - Parameter lentItem: <#lentItem description#>
    init() {
        self.lentItem = LentItemStoreModel.sampleData[0]
        self.id = UUID()
        self.nameText = "Unknown item"
        self.emojiText = "🤨"
        self.descriptionText = "Unknown item"
        //
        let numberFormat = NumberFormatter()
        numberFormat.locale = .current
        numberFormat.numberStyle = .currency
        if let value = numberFormat.string(from: NSNumber(value: 100)) {
            self.valueText = value
        } else {
            self.valueText = "?"
        }
        self.categoryText = "Unknown category"
        self.borrowerText = "Unknown borrower"
        self.lendDate = Date()
        //
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        self.lendDateText = dateFormat.string(from: Date())
        //
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .short
        timeFormat.allowedUnits = [.day, .month, .year]
        if let lendTime = timeFormat.string(from: 120000.0) {
            self.lendTimeText = lendTime
        } else {
            self.lendTimeText = "?"
        }
        self.lendExpiryText = dateFormat.string(from: Date(timeInterval: 120000.0, since: Date()))
    }
    /// Function to set lent item view model
    /// - Parameter lentItem: <#lentItem description#>
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
        //
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .short
        timeFormat.allowedUnits = [.day, .month, .year]
        if let lendTime = timeFormat.string(from: lentItem.lendTime) {
            self.lendTimeText = lendTime
        } else {
            self.lendTimeText = "?"
        }
        self.lendExpiryText = setLentItemExpiryText(for: lentItem.lendExpiry)
    }
    /// Function to set item lent date text
    /// - Parameter lendDate: Item lend Date
    /// - Returns: Item lend date String
    func setLentItemDateText(for lendDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let lendDateText: String = dateFormat.string(from: lendDate)
        return lendDateText
    }
    /// <#Description#>
    /// - Parameter lendExpiry: <#lendExpiry description#>
    /// - Returns: <#description#>
    func setLentItemExpiryText(for lendExpiry: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let lendExpiryText: String = dateFormat.string(from: lendExpiry)
        return lendExpiryText
    }
    /// <#Description#>
    /// - Parameters:
    ///   - lendDate: <#lendDate description#>
    ///   - lendTime: <#lendTime description#>
    /// - Returns: <#description#>
    func setLentItemExpiry(from lendDate: Date, lendTime: TimeInterval) -> Date {
        let lendExpiry: Date = Date(timeInterval: lendTime, since: lendDate)
        return lendExpiry
    }
}
