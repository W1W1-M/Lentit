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
    var id: UUID { get set }
// MARK: - Methods
    func setVM(from model: Model)
}
/// Description
class ViewModel: ViewModelProtocol, Identifiable {
// MARK: - Properties
    internal var id: UUID
// MARK: - Init & deinit
    init() {
        print("ViewModel init ...")
        self.id = UUID()
    }
    deinit {
        print("... deinit ViewModel \(id)")
    }
// MARK: - Methods
    func setVM(from model: Model) {
        print("setVM ...")
        self.id = model.id
    }
}
