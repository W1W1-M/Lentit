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
    static let justAdded: LoanStatusModel = LoanStatusModel(name: "Just added", symbolName: "plus.diamond.fill")
    static let inProgress: LoanStatusModel = LoanStatusModel(name: "In progress", symbolName: "play.circle.fill")
    static let finished: LoanStatusModel = LoanStatusModel(name: "Finished", symbolName: "stop.circle.fill")
    static let status: Array<LoanStatusModel> = [justAdded, inProgress, finished]
}
