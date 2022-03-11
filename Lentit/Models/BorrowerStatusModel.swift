//
//  BorrowerStatusModel.swift
//  Lentit
//
//  Created by William Mead on 11/03/2022.
//

import Foundation
/// Custom type for borrower status
struct BorrowerStatusModel: Identifiable, Hashable {
    // MARK: - Variables
    let id: UUID
    let name: String
    let symbolName: String
    // MARK: - Init
    /// Custom initialization
    /// - Parameter name: String to describe borrower
    init(name: String, symbolName: String) {
        self.id = UUID()
        self.name = name
        self.symbolName = symbolName
    }
}
/// Predefined loan status
struct BorrowerStatus {
    static let new: BorrowerStatusModel = BorrowerStatusModel(name: "New", symbolName: "play.circle")
    static let regular: BorrowerStatusModel = BorrowerStatusModel(name: "Regular", symbolName: "person.circle")
    static let unknown: BorrowerStatusModel = BorrowerStatusModel(name: "unknown", symbolName: "questionmark.circle")
    static let status: Array<BorrowerStatusModel> = [new, regular]
}
