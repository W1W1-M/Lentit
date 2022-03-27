//
//  ItemCategoryFullNameView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI
// MARK: - Views
struct ItemCategoryFullNameView: View {
    let itemCategory: ItemModel.Category
    var body: some View {
        switch itemCategory {
        case ItemModel.Category.all:
            Text("\(itemCategory.emoji) All")
        case ItemModel.Category.books:
            Text("\(itemCategory.emoji) Books")
        case ItemModel.Category.cars:
            Text("\(itemCategory.emoji) Cars")
        case ItemModel.Category.clothes:
            Text("\(itemCategory.emoji) Clothes")
        case ItemModel.Category.films:
            Text("\(itemCategory.emoji) Films")
        case ItemModel.Category.other:
            Text("\(itemCategory.emoji) Other")
        case ItemModel.Category.pens:
            Text("\(itemCategory.emoji) Pens")
        case ItemModel.Category.toys:
            Text("\(itemCategory.emoji) Toys")
        default:
            Text("Unknown")
        }
    }
}
// MARK: - Previews
struct ItemCategoryFullNameView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategoryFullNameView(itemCategory: ItemModel.Category.books).previewLayout(.sizeThatFits)
    }
}
