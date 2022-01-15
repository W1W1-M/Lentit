//
//  BorrowerModel.swift
//  Lentit
//
//  Created by William Mead on 15/01/2022.
//

import Foundation
// MARK: - Classes
/// Data model for a person who borrows something
class BorrowerModel: ObservableObject, Identifiable, Equatable, Hashable {
// MARK: - Variables
    @Published var id: UUID
    @Published var name: String
// MARK: - Init
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
// MARK: - Functions
    static func == (lhs: BorrowerModel, rhs: BorrowerModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
