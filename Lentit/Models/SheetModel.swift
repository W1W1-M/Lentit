//
//  SheetModel.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import Foundation
/// Custom type for sheets
struct SheetModel: Identifiable, Hashable, Equatable, CaseIterable {
    let id: UUID = UUID()
    static let borrowersList: SheetModel = SheetModel()
    static let itemsList: SheetModel = SheetModel()
    static let allCases: [SheetModel] = [borrowersList, itemsList]
}
