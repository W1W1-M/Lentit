//
//  ItemVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Item view model
class ItemVM: ObservableObject, Identifiable, Equatable, Hashable {
    // MARK: - Variables
    private(set) var item: ItemModel
    private(set) var id: UUID
    @Published var nameText: String
    @Published var category: ItemCategoryModel
    @Published var status: ItemStatusModel{
        didSet{
            item.status = self.status
        }
    }
    // MARK: - Init
    init() {
        self.item = ItemModel.defaultData
        self.id = ItemModel.defaultData.id
        self.nameText = ItemModel.defaultData.name
        self.category = ItemModel.defaultData.category
        self.status = ItemModel.defaultData.status
    }
    // MARK: - Functions
    func setItemVM(from itemModel: ItemModel) {
        self.item = itemModel
        self.id = itemModel.id
        self.nameText = itemModel.name
        self.category = itemModel.category
        self.status = itemModel.status
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ItemVM, rhs: ItemVM) -> Bool {
        lhs.id == rhs.id
    }
}
