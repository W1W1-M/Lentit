//
//  ViewModelProtocol.swift
//  Lentit
//
//  Created by William Mead on 08/04/2022.
//

import Foundation
/// View model protocol
protocol ViewModelProtocol: ObservableObject {
// MARK: - Properties
    associatedtype ModelType
    var model: ModelType { get set }
    var id: UUID { get set }
    var status: StatusModel { get set }
    var editDisabled: Bool { get set }
    var navigationLinkActive: Bool { get set }
// MARK: - Methods
    func setVM(from model: ModelType)
    func updateModel()
}
