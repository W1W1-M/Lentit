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
    @Published var nameText: String
    @Published var emojiText: String
    @Published var descriptionText: String
    @Published var valueText: String
    @Published var categoryText: String
    @Published var borrowerText: String
    @Published var lendDate: Date
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
        if let lendTime = timeFormat.string(from: 60000.0) {
            self.lendTimeText = lendTime
        } else {
            self.lendTimeText = "?"
        }
        self.lendExpiryText = dateFormat.string(from: Date(timeInterval: 60000.0, since: Date()))
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
        //
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        self.lendDateText = dateFormat.string(from: lentItem.lendDate)
        //
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .short
        timeFormat.allowedUnits = [.day, .month, .year]
        if let lendTime = timeFormat.string(from: lentItem.lendTime) {
            self.lendTimeText = lendTime
        } else {
            self.lendTimeText = "?"
        }
        self.lendExpiryText = dateFormat.string(from: lentItem.lendExpiry)
    }
}
