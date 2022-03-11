//
//  ItemListView.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemListVM: ItemListVM
    @ObservedObject var loanVM: LoanVM
    @Binding var sheetPresented: Bool
    var body: some View {
        NavigationView {
            List {
                if(itemListVM.newItemPresented) {
                    Section(header: Text("🆕 New item")) {
                        TextField("Name", text: $itemListVM.newItemName)
                        TextField("Value", text: $itemListVM.newItemValueText)
                        Picker("Category", selection: $itemListVM.newItemCategory) {
                            ForEach(ItemCategories.categories) { ItemCategoryModel in
                                Text("\(ItemCategoryModel.fullName)").tag(ItemCategoryModel)
                            }
                        }.pickerStyle(.menu)
                    }
                    Section {
                        Button {
                            appVM.createItem(
                                id: itemListVM.newItemId,
                                named: itemListVM.newItemName,
                                worth: itemListVM.newItemValue,
                                typed: itemListVM.newItemCategory
                            )
                            loanVM.setLoanItem(to: appVM.getItem(with: itemListVM.newItemId))
                            itemListVM.hideNewItem()
                            sheetPresented = false
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "bag.badge.plus").imageScale(.large)
                                Text("Save new item")
                                Spacer()
                           }
                        }.font(.headline)
                        .foregroundColor(.white)
                    }.listRowBackground(Color("InvertedAccentColor"))
                }
                Section(header: Text("\(itemListVM.itemsCountText) items")) {
                    ForEach(appVM.itemVMs) { ItemVM in
                        Button {
                            loanVM.setLoanItem(to: ItemVM)
                            sheetPresented = false
                        } label: {
                            HStack {
                                Text("\(ItemVM.nameText)")
                                Spacer()
                                if(loanVM.itemVM.id == ItemVM.id) {
                                    Image(systemName: "checkmark")
                                } else {
                                    Image(systemName: "\(ItemVM.status.symbolName)")
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("📦 Items")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        itemListVM.hideNewItem()
                        sheetPresented = false
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        itemListVM.showNewItem()
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .onChange(of: itemListVM.newItemValueText, perform: { _ in
                // Filter unwanted characters & set value text
                itemListVM.newItemValueText = itemListVM.filterItemValueText(for: itemListVM.newItemValueText)
                itemListVM.newItemValueText = itemListVM.setItemValueText(for: itemListVM.newItemValue)
            })
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(
            itemListVM: ItemListVM(),
            loanVM: LoanVM(),
            sheetPresented: .constant(true)
        ).environmentObject(AppVM())
    }
}
