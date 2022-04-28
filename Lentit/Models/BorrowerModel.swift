//
//  BorrowerModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
/// Data model for a person who borrows an item
final class BorrowerModel: ModelProtocol, ObservableObject, Equatable, Hashable {
// MARK: - Properties
    internal var id: UUID
    internal var name: String
    internal var status: StatusModel
    internal var contactLink: Bool
    internal var contactId: String?
    internal var loanIds: Set<UUID>
// MARK: - Init & deinit
    init(
        name: String,
        status: StatusModel,
        contactLink: Bool,
        contactId: String?,
        loanIds: Set<UUID>
    ) {
        print("BorrowerModel init ...")
        self.id = UUID()
        self.name = name
        self.status = status
        self.contactLink = false
        self.contactId = contactId
        self.loanIds = []
    }
    deinit {
        print("BorrowerModel init ...")
    }
// MARK: - Methods
    func addLoanId(with loanId: UUID) {
        self.loanIds.insert(loanId)
    }
    func removeLoanId(with loanId: UUID) {
        self.loanIds.remove(loanId)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BorrowerModel, rhs: BorrowerModel) -> Bool {
        lhs.id == rhs.id
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
