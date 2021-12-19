//
//  LentItem.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import Foundation

class LentItem: ObservableObject, Identifiable {
    var id: UUID = UUID()
    @Published var name: String = "Ironman bluray"
    @Published var emoji: String = "💽"
    @Published var category: String = "Films"
    @Published var borrower: String = "Sarah"
    @Published var borrowDate: String = "01/01/2022"
    @Published var borrowTime: String = "2 weeks"
}
