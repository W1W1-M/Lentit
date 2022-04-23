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
/// Description
class Model: ModelProtocol, Identifiable {
    // MARK: - Properties
    internal var id: UUID
    internal var status: StatusModel
    // MARK: - Init & deinit
    init(status: StatusModel) {
        print("Model init ...")
        self.id = UUID()
        self.status = status
    }
    deinit {
        print("... deinit Model \(id)")
    }
    // MARK: - Methods
}
//
extension Model {
    static var defaultModelData: Model = Model(status: .unknown)
}
