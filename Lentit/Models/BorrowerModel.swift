//
//  BorrowerModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Data model for a person who borrows an item
final class BorrowerModel: Model, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    var name: String
    var contactLink: Bool
    var contactId: String?
    var loanIds: Set<UUID>
// MARK: - Init & deinit
    init(
        name: String,
        status: StatusModel,
        contactLink: Bool,
        contactId: String?,
        loanIds: Set<UUID>
    ) {
        print("BorrowerModel init ...")
        self.name = name
        self.contactLink = false
        self.contactId = contactId
        self.loanIds = []
        super.init(status: status)
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
    static var defaultBorrowerData: BorrowerModel = BorrowerModel(
        name: "Unknown borrower",
        status: StatusModel.unknown,
        contactLink: false,
        contactId: nil,
        loanIds: [UUID()]
    )
}
