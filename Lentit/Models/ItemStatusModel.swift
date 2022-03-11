//
//  ItemStatusModel.swift
//  Lentit
//
//  Created by William Mead on 23/02/2022.
//

import Foundation
/// Custom type for item status
struct ItemStatusModel: Identifiable, Hashable {
    // MARK: - Variables
    let id: UUID
    let name: String
    let symbolName: String
    // MARK: - Init
    /// Custom initialization
    /// - Parameter name: String to describe status
    init(name: String, symbolName: String) {
        self.id = UUID()
        self.name = name
        self.symbolName = symbolName
    }
}
/// Predefined loan status
struct ItemStatus {
    static let new: ItemStatusModel = ItemStatusModel(name: "New", symbolName: "play.circle")
    static let available: ItemStatusModel = ItemStatusModel(name: "available", symbolName: "checkmark.circle")
    static let unavailable: ItemStatusModel = ItemStatusModel(name: "unavailable", symbolName: "xmark.circle")
    static let unknown: ItemStatusModel = ItemStatusModel(name: "unknown", symbolName: "questionmark.circle")
    static let status: Array<ItemStatusModel> = [new, available, unavailable]
}
