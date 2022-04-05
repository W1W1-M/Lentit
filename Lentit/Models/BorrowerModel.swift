//
//  BorrowerModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Data model for a person who borrows an item
final class BorrowerModel: ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Properties
    let id: UUID
    var name: String
    var status: BorrowerModel.Status
    var loanIds: Set<UUID>
// MARK: - Init & deinit
    init(
        name: String,
        status: BorrowerModel.Status,
        loanIds: Set<UUID>
    ) {
        print("BorrowerModel init ...")
        self.id = UUID()
        self.name = name
        self.status = status
        self.loanIds = []
    }
    deinit {
        print("BorrowerModel init ...")
    }
// MARK: - Methods
    static func == (lhs: BorrowerModel, rhs: BorrowerModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    func addLoanId(with loanId: UUID) {
        self.loanIds.insert(loanId)
    }
    func removeLoanId(with loanId: UUID) {
        self.loanIds.remove(loanId)
    }
}

extension BorrowerModel {
    /// Predefined borrower status
    struct Status: Identifiable, Equatable, Hashable, CaseIterable {
        let id: UUID = UUID()
        let symbolName: String
        static let new: Status = Status(symbolName: "play.circle")
        static let regular: Status = Status(symbolName: "person.circle")
        static let unknown: Status = Status(symbolName: "questionmark.circle")
        static let allCases: Array<BorrowerModel.Status> = [new, regular]
    }
}

extension BorrowerModel {
    static var defaultData: BorrowerModel = BorrowerModel(
        name: "Unknown borrower",
        status: BorrowerModel.Status.unknown,
        loanIds: [UUID()]
    )
}
