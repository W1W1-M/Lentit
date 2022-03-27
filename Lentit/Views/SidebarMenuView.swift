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
                appVM.activeItemCategory = ItemModel.Category.all
            } label: {
                HStack {
                    ItemCategoryFullNameView(itemCategory: ItemModel.Category.all)
                    Spacer()
                    if(appVM.activeItemCategory == ItemModel.Category.all) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(ItemModel.Category.allCases) { Category in
                Button {
                    appVM.activeItemCategory = Category
                } label: {
                    HStack {
                        ItemCategoryFullNameView(itemCategory: Category)
                        Spacer()
                        if(appVM.activeItemCategory == Category) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
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
