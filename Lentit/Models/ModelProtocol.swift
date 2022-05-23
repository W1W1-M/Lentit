//
//  ModelProtocol.swift
//  Lentit
//
//  Created by William Mead on 08/04/2022.
//

import Foundation
/// Model protocol
protocol ModelProtocol: AnyObject {
// MARK: - Properties
    var id: UUID { get }
    var status: StatusModel { get set }
// MARK: - Methods
}
extension ModelProtocol {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
