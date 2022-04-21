//
//  ModelProtocol.swift
//  Lentit
//
//  Created by William Mead on 08/04/2022.
//

import Foundation
/// Model protocol
protocol Model {
// MARK: - Properties
    var id: UUID { get }
    var status: StatusModel { get set }
// MARK: - Methods
    
}