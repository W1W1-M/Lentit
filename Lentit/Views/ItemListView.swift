//
//  ItemListView.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import SwiftUI
// MARK: - Views
struct ItemListStatusView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemListVM: ItemListVM
    var body: some View {
        HStack {
            Text("\(itemListVM.itemsCount) items")
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Spacer()
            Menu {
                ForEach(ItemModel.Status.allCases) { Status in
                    Button {
                        appVM.activeItemStatus = Status
                    } label: {
                        ItemStatusNameView(itemStatus: Status)
                        Image(systemName: Status.symbolName)
                    }
                }
            } label: {
                switch appVM.activeItemStatus {
                case .all:
                    Text("all")
                        .fontWeight(.bold)
                        .fixedSize()
                case .available:
                    Text("available")
                        .fontWeight(.bold)
                        .fixedSize()
                case .unavailable:
                    Text("unavailable")
                        .fontWeight(.bold)
                        .fixedSize()
                default:
                    Text("unknown")
                }
                ActiveItemStatusIconView()
            }
        }.font(.title3)
        .textCase(.lowercase)
        .padding(.bottom)
    }
}
// MARK: -
struct ItemListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemListVM: ItemListVM
    var body: some View {
        List {
            Section {
                ForEach(appVM.itemListEntryVMs) { ItemListEntryVM in
                    ItemListItemView(itemListEntryVM: ItemListEntryVM)
                }
            } header: {
                ItemListStatusView(itemListVM: appVM.itemListVM)
            }
        }.listStyle(.plain)
    }
}
// MARK: -
struct ItemListItemView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemListEntryVM: ItemListEntryVM
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: ItemDetailView(
                itemVM: appVM.getItemVM(for: itemListEntryVM.id),
                navigationLinkIsActive: $navigationLinkIsActive
            ),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                    Text("\(String(itemListEntryVM.name.prefix(2)))")
                        .font(.title2)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                Text("\(itemListEntryVM.name)").foregroundColor(.primary)
                Spacer()
                Text("\(itemListEntryVM.category.emoji)")
            }
        }.onAppear(perform: {
            // Programmatic navigation to newly added item
            if(itemListEntryVM.status == ItemModel.Status.new) {
                navigationLinkIsActive = true
            }
        })
    }
}
// MARK: -
struct ItemListBottomToolbarView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        Group {
            Menu {
                CategoriesListMenuItems()
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Category")
                }
            }
            Menu {
                ForEach(ItemModel.SortingOrder.allCases) { SortingOrder in
                    Button {
                        appVM.activeItemSort = SortingOrder
                    } label: {
                        HStack {
                            switch SortingOrder {
                            case ItemModel.SortingOrder.byName:
                                Text("by Name")
                            default:
                                Text("")
                            }
                            if(appVM.activeItemSort == SortingOrder) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Sort")
                    Image(systemName: "arrow.up.arrow.down.circle")
                }
            }
        }
    }
}
// MARK: -
struct ItemListSheetView: View {
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
                                    typed: itemListVM.newItemCategory
                                )
                                // loanVM.setLoanItem(to: try appVM.dataStore.readStoredItem(itemListVM.newItemId))
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
                        ForEach(appVM.itemListEntryVMs) { ItemListEntryVM in
                            ItemListItemButtonView(
                                loanVM: loanVM,
                                itemListEntryVM: ItemListEntryVM
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
            }
        }
    }
}
// MARK: -
struct ItemListItemButtonView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var itemListEntryVM : ItemListEntryVM
    var body: some View {
        Button {
            loanVM.setLoanItem(to: itemListEntryVM.item)
            appVM.sheetPresented = false
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                    Text("\(String(itemListEntryVM.name.prefix(2)))")
                        .font(.title)
                        .foregroundColor(.white)
                }.padding(.horizontal, 4)
                VStack {
                    HStack {
                        Text("\(itemListEntryVM.name)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }.padding(2)
                    HStack {
                        ItemCategoryFullNameView(itemCategory: itemListEntryVM.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }.padding(2)
                }
                HStack {
                    if(loanVM.loanItem.id == itemListEntryVM.id) {
                        Image(systemName: "checkmark").imageScale(.large)
                    } else {
                        Image(systemName: "\(itemListEntryVM.status.symbolName)").imageScale(.large)
                    }
                }
            }.padding(2)
        }
    }
}
// MARK: - Previews
struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        //
        ItemListView(itemListVM: ItemListVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        ItemListSheetView(
            itemListVM: ItemListVM(),
            loanVM: LoanVM()
        ).environmentObject(AppVM())
        //
        ItemListStatusView(itemListVM: ItemListVM())
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        ItemListItemButtonView(
            loanVM: LoanVM(),
            itemListEntryVM: ItemListEntryVM()
        ).previewLayout(.sizeThatFits)
    }
}
