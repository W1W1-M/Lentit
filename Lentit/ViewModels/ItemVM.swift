//
//  ItemVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Item view model
class ItemVM: ObservableObject, Identifiable {
    // MARK: - Variables
    var item: ItemModel
    @Published var id: UUID
    @Published var nameText: String
    @Published var category: ItemCategoryModel
    @Published var itemJustAdded: Bool{
        didSet{
            item.justAdded = self.itemJustAdded
        }
    }
    // MARK: - Init
    init() {
        self.item = DataStoreModel.defaultItemData
        self.id = DataStoreModel.defaultItemData.id
        self.nameText = DataStoreModel.defaultItemData.name
        self.category = ItemCategories.categories[4]
        self.itemJustAdded = DataStoreModel.defaultItemData.justAdded
    }
    // MARK: - Functions
    func setItemVM(from itemModel: ItemModel) {
        self.item = itemModel
        self.id = itemModel.id
        self.nameText = itemModel.name
        self.category = itemModel.category
        self.itemJustAdded = itemModel.justAdded
    }
}
