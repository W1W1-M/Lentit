//
//  SidebarMenuView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct SidebarMenuView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        List {
            Section(header:
                HStack {
                    Image(systemName: "list.dash")
                    Text("Categories")
                }
            ) {
                CategoriesListMenuItems()
            }
            Section(header:
                HStack {
                    Image(systemName: "person.2")
                    Text("Borrowers")
                }
            ) {
                BorrowersListMenuItems()
            }
            Section(header:
                HStack {
                    Image(systemName: "archivebox")
                    Text("Items")
                }
            ) {
                ItemsListMenuItems()
            }
        }.listStyle(SidebarListStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
}
// MARK: -
struct CategoriesListMenuItems: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        Group {
            Button {
                appVM.activeCategory = ItemCategories.all
            } label: {
                HStack {
                    ItemCategoryFullNameView(itemCategoryModel: ItemCategories.all)
                    Spacer()
                    if(appVM.activeCategory == ItemCategories.all) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(ItemCategories.categories) { ItemCategoryModel in
                Button {
                    appVM.activeCategory = ItemCategoryModel
                } label: {
                    HStack {
                        ItemCategoryFullNameView(itemCategoryModel: ItemCategoryModel)
                        Spacer()
                        if(appVM.activeCategory == ItemCategoryModel) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
    }
}
// MARK: -
struct ItemCategoryFullNameView: View {
    let itemCategoryModel: ItemCategoryModel
    var body: some View {
        switch itemCategoryModel {
        case ItemCategories.all:
            Text("\(itemCategoryModel.emoji) All")
        case ItemCategories.books:
            Text("\(itemCategoryModel.emoji) Books")
        case ItemCategories.cars:
            Text("\(itemCategoryModel.emoji) Cars")
        case ItemCategories.clothes:
            Text("\(itemCategoryModel.emoji) Clothes")
        case ItemCategories.films:
            Text("\(itemCategoryModel.emoji) Films")
        case ItemCategories.other:
            Text("\(itemCategoryModel.emoji) Other")
        case ItemCategories.pens:
            Text("\(itemCategoryModel.emoji) Pens")
        case ItemCategories.toys:
            Text("\(itemCategoryModel.emoji) Toys")
        default:
            Text("Unknown")
        }
    }
}
// MARK: -
struct BorrowersListMenuItems: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        ForEach(appVM.borrowerVMs) { BorrowerVM in
            Button {
                appVM.activeBorrower = BorrowerVM
            } label: {
                if(appVM.activeBorrower.id == BorrowerVM.id) {
                    HStack {
                        Text("\(BorrowerVM.nameText)")
                        Spacer()
                        Image(systemName: "checkmark").foregroundColor(.accentColor)
                    }
                } else {
                    Text("\(BorrowerVM.nameText)")
                }
            }
        }
    }
}
// MARK: -
struct ItemsListMenuItems: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        ForEach(appVM.itemVMs) { ItemVM in
            Button {
                appVM.activeItem = ItemVM
            } label: {
                if(appVM.activeItem.id == ItemVM.id) {
                    HStack {
                        Text("\(ItemVM.nameText)")
                        Spacer()
                        Image(systemName: "checkmark").foregroundColor(.accentColor)
                    }
                } else {
                    Text("\(ItemVM.nameText)")
                }
            }
        }
    }
}
// MARK: - Previews
struct SidebarMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SidebarMenuView()
        }.environmentObject(AppVM())
    }
}
