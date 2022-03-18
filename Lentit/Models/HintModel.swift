//
//  HintModel.swift
//  Lentit
//
//  Created by William Mead on 14/03/2022.
//

import Foundation
/// Description
struct HintModel: Identifiable {
    // MARK: - Variables
    let id: UUID
    let hintSymbol1: String
    let hintSymbol2: String
    // MARK: - Init
    /// <#Description#>
    /// - Parameter name: <#name description#>
    init(hintSymbol1: String, hintSymbol2: String) {
        self.id = UUID()
        self.hintSymbol1 = hintSymbol1
        self.hintSymbol2 = hintSymbol2
    }
}

struct Tips {
    static let createLoan: HintModel = HintModel(hintSymbol1: "eyes", hintSymbol2: "arrow.down.circle")
    static let selectLoan: HintModel = HintModel(hintSymbol1: "questionmark.app.dashed", hintSymbol2: "arrow.left.circle")
}
