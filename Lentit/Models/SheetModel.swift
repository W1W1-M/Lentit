//
//  SheetModel.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import Foundation
/// Custom type for sheets
struct SheetModel: Identifiable, Hashable {
    // MARK: - Variables
    let id: UUID
    let name: String
    // MARK: - Init
    /// <#Description#>
    /// - Parameter name: <#name description#>
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    // MARK: - Functions
}

struct Sheets {
    static let borrowersList: SheetModel = SheetModel(name: "borrowersList")
    static let itemsList: SheetModel = SheetModel(name: "itemsList")
}
