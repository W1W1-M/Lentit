//
//  BorrowerModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
// MARK: - Classes
/// Data model for a person who borrows an item
class BorrowerModel: ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Variables
    var id: UUID
    var name: String
    var status: BorrowerStatusModel
    var loanIds: [UUID]
// MARK: - Init
    init(
        id: UUID,
        name: String,
        status: BorrowerStatusModel,
        loanIds: [UUID]
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.loanIds = []
    }
// MARK: - Functions
    static func == (lhs: BorrowerModel, rhs: BorrowerModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension BorrowerModel {
    static var defaultData: BorrowerModel = BorrowerModel(
        id: UUID(),
        name: "Unknown borrower",
        status: BorrowerStatus.unknown,
        loanIds: [UUID()]
    )
}
