//
//  LoanStatusModel.swift
//  Lentit
//
//  Created by William Mead on 20/02/2022.
//

import Foundation
/// Custom type for loan filters
struct LoanStatusModel: Identifiable, Hashable {
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
struct LoanStatus {
    static let new: LoanStatusModel = LoanStatusModel(name: "New", symbolName: "play.circle")
    static let upcoming: LoanStatusModel = LoanStatusModel(name: "Upcoming", symbolName: "calendar.circle")
    static let current: LoanStatusModel = LoanStatusModel(name: "Current", symbolName: "hourglass.circle")
    static let finished: LoanStatusModel = LoanStatusModel(name: "Finished", symbolName: "stop.circle")
    static let status: Array<LoanStatusModel> = [upcoming, current, finished]
}
