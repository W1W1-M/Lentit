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
        }.listStyle(SidebarListStyle())
        .navigationTitle("📒 Lentit")
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
                    Text(ItemCategories.all.fullName)
                    if(appVM.activeCategory == ItemCategories.all) {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(ItemCategories.categories) { LentItemCategoryModel in
                Button {
                    appVM.activeCategory = LentItemCategoryModel
                } label: {
                    if(appVM.activeCategory == LentItemCategoryModel) {
                        HStack {
                            Text("\(LentItemCategoryModel.fullName)")
                            Spacer()
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    } else {
                        Text("\(LentItemCategoryModel.fullName)")
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
                
            } label: {
                HStack {
                    Text("\(BorrowerVM.nameText)")
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
