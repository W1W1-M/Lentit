//
//  LoanFilterModel.swift
//  Lentit
//
//  Created by William Mead on 20/02/2022.
//

import Foundation
/// Custom type for loan filters
struct LoanFilterModel: Identifiable, Hashable {
    // MARK: - Variables
    let id: UUID
    let name: String
    let symbolName: String
    // MARK: - Init
    /// Custom initialization
    /// - Parameter name: String to describe filter
    init(name: String, symbolName: String) {
        self.id = UUID()
        self.name = name
        self.symbolName = symbolName
    }
}
/// Predefined loan filters
struct LoanFilters {
    static let inProgress: LoanFilterModel = LoanFilterModel(name: "In progress", symbolName: "play.circle.fill")
    static let finished: LoanFilterModel = LoanFilterModel(name: "finished", symbolName: "stop.circle.fill")
    static let filters: Array<LoanFilterModel> = [inProgress, finished]
}
