//
//  ItemListEntryVM.swift
//  Lentit
//
//  Created by William Mead on 04/04/2022.
//

import Foundation
/// Item list entry view model
final class ItemListEntryVM: ObservableObject, Identifiable {
// MARK: - Properties
    private(set) var item: ItemModel
    private(set) var id: UUID
    @Published var name: String
    @Published var category: ItemModel.Category
    @Published var status: StatusModel
// MARK: - Init & deinit
    init() {
        print("ItemListEntryVM init ...")
        self.item = ItemModel.defaultData
        self.id = UUID()
        self.name = ItemModel.defaultData.name
        self.category = ItemModel.defaultData.category
        self.status = ItemModel.defaultData.status
    }
    deinit {
        print("... deinit ItemListEntryVM \(id)")
    }
// MARK: - Methods
    func setVM(from item: ItemModel) {
        print("setVM \(item.id) ...")
        self.item = item
        self.id = item.id
        self.name = item.name
        self.category = item.category
        self.status = item.status
    }
}
