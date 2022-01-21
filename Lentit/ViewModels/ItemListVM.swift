//
//  ItemListVM.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import Foundation

/// Item list view model
class ItemListVM: ObservableObject {
    // MARK: - Variables
    @Published var itemsCountText: String
    // MARK: - Init
    init() {
        self.itemsCountText = "0"
    }
    // MARK: - Functions
    func setItemsCount(for itemVMs: [ItemVM]) {
        self.itemsCountText = "\(itemVMs.count)"
    }
}
