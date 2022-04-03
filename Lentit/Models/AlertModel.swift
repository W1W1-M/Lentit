//
//  AlertModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Custom type for alerts
struct AlertModel: Identifiable, Hashable, Equatable, CaseIterable {
    let id: UUID = UUID()
    static let deleteLoan: AlertModel = AlertModel()
    static let deleteBorrower: AlertModel = AlertModel()
    static let deleteItem: AlertModel = AlertModel()
    static let reminderAdded: AlertModel = AlertModel()
    static let reminderNotAdded: AlertModel = AlertModel()
    static let reminderDeleted: AlertModel = AlertModel()
    static let reminderNotDeleted: AlertModel = AlertModel()
    static let allCases: [AlertModel] = [deleteLoan, deleteBorrower, deleteItem, reminderAdded, reminderNotAdded]
}
