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
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                List {
                    if(itemListVM.newItemPresented) {
                        Section(header: Text("🆕 New item")) {
                            TextField("Name", text: $itemListVM.newItemName).disableAutocorrection(true)
                            TextField("Value", text: $itemListVM.newItemValueText)
                            Picker("Category", selection: $itemListVM.newItemCategory) {
                                ForEach(ItemModel.Category.allCases) { Category in
                                    ItemCategoryFullNameView(itemCategory: Category).tag(Category)
                                }
                            }.pickerStyle(.menu)
                        }
                        Section {
                            Button {
                                itemListVM.newItemId = appVM.createItem(
                                    named: itemListVM.newItemName,
                                    worth: itemListVM.newItemValue,
                                    typed: itemListVM.newItemCategory
                                )
                                loanVM.setLoanItem(to: appVM.getItem(with: itemListVM.newItemId))
                                itemListVM.hideNewItem()
                                appVM.sheetPresented = false
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
                    Section(header: Text("\(itemListVM.itemsCount) items")) {
                        ForEach(appVM.itemVMs) { ItemVM in
                            ItemListItemButtonView(
                                loanVM: loanVM,
                                itemVM: ItemVM
                            )
                        }
                    }
                }.navigationTitle("📦 Items")
                .listStyle(.insetGrouped)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            itemListVM.hideNewItem()
                            appVM.sheetPresented = false
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
                .onAppear(perform: {
                    // Background color fix
                    UITableView.appearance().backgroundColor = .clear
                })
                .onChange(of: itemListVM.newItemValueText, perform: { _ in
                    // Filter unwanted characters & set value text
                    itemListVM.newItemValueText = itemListVM.filterItemValueText(for: itemListVM.newItemValueText)
                    itemListVM.newItemValueText = itemListVM.setItemValueText(for: itemListVM.newItemValue)
            })
            }
        }
    }
}
// MARK: -
struct ItemListItemButtonView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var itemVM : ItemVM
    var body: some View {
        Button {
            loanVM.setLoanItem(to: itemVM)
            appVM.sheetPresented = false
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                    Text("\(String(itemVM.nameText.prefix(2)))")
                        .font(.title)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                VStack {
                    HStack {
                        Text("\(itemVM.nameText)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }.padding(2)
                    HStack {
                        ItemCategoryFullNameView(itemCategory: itemVM.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }.padding(2)
                }
                HStack {
                    if(loanVM.itemVM.id == itemVM.id) {
                        Image(systemName: "checkmark").imageScale(.large)
                    } else {
                        Image(systemName: "\(itemVM.status.symbolName)").imageScale(.large)
                    }
                }
            }.padding(2)
        }
    }
}
// MARK: - Previews
struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(
            itemListVM: ItemListVM(),
            loanVM: LoanVM()
        ).environmentObject(AppVM())
        //
        ItemListItemButtonView(
            loanVM: LoanVM(),
            itemVM: ItemVM()
        ).previewLayout(.sizeThatFits)
    }
}
