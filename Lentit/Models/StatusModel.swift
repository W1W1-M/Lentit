//
//  StatusModel.swift
//  Lentit
//
//  Created by William Mead on 08/04/2022.
//

import Foundation
/// Predefined borrower status
struct StatusModel: Statable, Identifiable, Equatable, Hashable, CaseIterable {
    let id: UUID = UUID()
    let symbolName: String
    let sortingOrder: Int
    static let all: StatusModel = StatusModel(symbolName: "infinity.circle", sortingOrder: 0)
    static let new: StatusModel = StatusModel(symbolName: "play.circle", sortingOrder: 1)
    static let unknown: StatusModel = StatusModel(symbolName: "questionmark.circle", sortingOrder: -1)
    static let regular: StatusModel = StatusModel(symbolName: "person.circle", sortingOrder: 2)
    static let upcoming: StatusModel = StatusModel(symbolName: "calendar.circle", sortingOrder: 3)
    static let current: StatusModel = StatusModel(symbolName: "hourglass.circle", sortingOrder: 4)
    static let finished: StatusModel = StatusModel(symbolName: "stop.circle", sortingOrder: 5)
    static let available: StatusModel = StatusModel(symbolName: "checkmark.circle", sortingOrder: 2)
    static let unavailable: StatusModel = StatusModel(symbolName: "xmark.circle", sortingOrder: 3)
    static let loanStatusCases: Array<StatusModel> = [all, upcoming, current, finished]
    static let itemStatusCases: Array<StatusModel> = [all, available, unavailable]
    static let borrowerStatusCases: Array<StatusModel> = [all, new, regular, unknown]
    static let allCases: Array<StatusModel> = [all, new, unknown]
}
