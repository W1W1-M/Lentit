//
//  StatableProtocol.swift
//  Lentit
//
//  Created by William Mead on 08/04/2022.
//

import Foundation
/// Status protocol
protocol Statable {
    // MARK: - Properties
    var id: UUID { get }
    var symbolName: String { get }
    // MARK: - Methods
}
