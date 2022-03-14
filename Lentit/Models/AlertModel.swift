//
//  AlertModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Custom type for alerts
struct AlertModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    /// Custom initialization
    /// - Parameter name: String to describe alert
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

/// Predefined  alerts
struct Alerts {
    static let deleteLoan: AlertModel = AlertModel(name: "deleteLoan")
    static let deleteItem: AlertModel = AlertModel(name: "deleteItem")
    static let deleteBorrower: AlertModel = AlertModel(name: "deleteBorrower")
}
