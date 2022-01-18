//
//  LoanVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Loan view model
class LoanVM: ObservableObject, Identifiable {
    // MARK: - Variables
    @Published var id: UUID
    // MARK: - Init
    init() {
        self.id = UUID()
    }
    // MARK: - Functions
}
