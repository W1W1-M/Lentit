//
//  LentItemVM.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import Foundation
import SwiftUI

/// <#Description#>
class LentItemVM: ObservableObject, Identifiable {
    var id: UUID
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
    /// <#Description#>
    /// - Parameter lentItem: <#lentItem description#>
    init(lentItem: LentItemModel) {
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
