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
    var item: ItemModel
    @Published var id: UUID
    @Published var nameText: String
    @Published var category: ItemCategoryModel
    @Published var status: ItemStatusModel{
        didSet{
            item.status = self.status
        }
    }
    // MARK: - Init
    init() {
        self.item = DataStoreModel.defaultItemData
        self.id = DataStoreModel.defaultItemData.id
        self.nameText = DataStoreModel.defaultItemData.name
        self.category = ItemCategories.categories[4]
        self.status = DataStoreModel.defaultItemData.status
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
