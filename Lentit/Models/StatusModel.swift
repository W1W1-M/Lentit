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
    static let all: StatusModel = StatusModel(symbolName: "infinity.circle")
    static let new: StatusModel = StatusModel(symbolName: "play.circle")
    static let unknown: StatusModel = StatusModel(symbolName: "questionmark.circle")
    static let regular: StatusModel = StatusModel(symbolName: "person.circle")
    static let upcoming: StatusModel = StatusModel(symbolName: "calendar.circle")
    static let current: StatusModel = StatusModel(symbolName: "hourglass.circle")
    static let finished: StatusModel = StatusModel(symbolName: "stop.circle")
    static let available: StatusModel = StatusModel(symbolName: "checkmark.circle")
    static let unavailable: StatusModel = StatusModel(symbolName: "xmark.circle")
    static let loanStatusCases: Array<StatusModel> = [all, upcoming, current, finished]
    static let itemStatusCases: Array<StatusModel> = [all, available, unavailable]
    static let borrowerStatusCases: Array<StatusModel> = [all, new, regular, unknown]
    static let allCases: Array<StatusModel> = [all, new, unknown]
}
