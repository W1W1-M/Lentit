//
//  SidebarMenuView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct SidebarMenuView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
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
                HStack {
                    Text("?")
                    Spacer()
                }
            }
        }.listStyle(SidebarListStyle())
        .navigationTitle("📒 Lentit")
    }
}
// MARK: -
struct CategoriesListMenuItems: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    var body: some View {
        Group {
            Button {
                lentItemsListVM.activeCategory = ItemCategories.all
            } label: {
                HStack {
                    Text("🗂 All")
                    if(lentItemsListVM.activeCategory == ItemCategories.all) {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(ItemCategories.categories) { LentItemCategoryModel in
                Button {
                    lentItemsListVM.activeCategory = LentItemCategoryModel
                } label: {
                    if(lentItemsListVM.activeCategory == LentItemCategoryModel) {
                        HStack {
                            Text("\(LentItemCategoryModel.name)")
                            Spacer()
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    } else {
                        Text("\(LentItemCategoryModel.name)")
                    }
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
        }.environmentObject(LentItemListVM())
    }
}
