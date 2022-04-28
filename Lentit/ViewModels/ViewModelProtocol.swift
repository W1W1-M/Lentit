//
//  ViewModelProtocol.swift
//  Lentit
//
//  Created by William Mead on 08/04/2022.
//

import Foundation
/// View model protocol
protocol ViewModelProtocol: AnyObject {
// MARK: - Properties
    associatedtype ModelType
    var model: ModelType { get set }
    var id: UUID { get set }
    var status: StatusModel { get set }
// MARK: - Methods
    func setVM(from model: ModelType)
}
