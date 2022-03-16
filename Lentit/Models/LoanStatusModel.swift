//
//  LoanStatusModel.swift
//  Lentit
//
//  Created by William Mead on 20/02/2022.
//

import Foundation
/// Custom type for loan status
struct LoanStatusModel: Identifiable, Hashable {
    // MARK: - Variables
    let id: UUID
    let symbolName: String
    // MARK: - Init
    /// Custom initialization
    /// - Parameter name: String to describe status
    init(symbolName: String) {
        self.id = UUID()
        self.symbolName = symbolName
    }
}
/// Predefined loan status
struct LoanStatus {
    static let new: LoanStatusModel = LoanStatusModel(symbolName: "play.circle")
    static let unknown: LoanStatusModel = LoanStatusModel(symbolName: "questionmark.circle")
    static let upcoming: LoanStatusModel = LoanStatusModel(symbolName: "calendar.circle")
    static let current: LoanStatusModel = LoanStatusModel(symbolName: "hourglass.circle")
    static let finished: LoanStatusModel = LoanStatusModel(symbolName: "stop.circle")
    static let status: Array<LoanStatusModel> = [upcoming, current, finished]
}
