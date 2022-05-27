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
    internal var firstName: String
    internal var lastName: String
    internal var status: StatusModel
    internal var contactLink: Bool
    internal var contactId: String?
    internal var thumbnailImage: Data?
    internal var loanIds: Set<UUID>
// MARK: - Init & deinit
    init(
        firstName: String,
        lastName: String,
        status: StatusModel,
        contactLink: Bool,
        contactId: String?,
        thumbnailImage: Data?,
        loanIds: Set<UUID>
    ) {
        print("BorrowerModel init ...")
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        self.contactLink = contactLink
        self.contactId = contactId
        self.thumbnailImage = thumbnailImage
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
    static func == (lhs: BorrowerModel, rhs: BorrowerModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension BorrowerModel {
    static let defaultData: BorrowerModel = BorrowerModel(
        firstName: "Unknown",
        lastName: "Unknown",
        status: StatusModel.unknown,
        contactLink: false,
        contactId: nil,
        thumbnailImage: nil,
        loanIds: [UUID()]
    )
}
