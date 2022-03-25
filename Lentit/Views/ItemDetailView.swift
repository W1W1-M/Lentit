//
//  ItemDetailView.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import SwiftUI
// MARK: - Views
struct ItemDetailView: View {
    @ObservedObject var itemVM: ItemVM
    @State var editDisabled: Bool = true
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            List {
                ItemDetailSectionView(itemVM: itemVM)
                ItemHistorySectionView(itemVM: itemVM)
            }.listStyle(.insetGrouped)
        }.navigationTitle("\(itemVM.nameText)")
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
            // Unlock edit mode if item just added
            if(itemVM.status == ItemModel.Status.new) {
                editDisabled = false
            }
        })
        .onChange(of: itemVM.valueText, perform: { _ in
            // Filter unwanted characters & set value text
            itemVM.valueText = itemVM.filterItemValueText(for: itemVM.valueText)
            itemVM.valueText = itemVM.setItemValueText(for: itemVM.valueText)
        })
        .onDisappear(perform: {
            if(itemVM.status == ItemModel.Status.new) {
                itemVM.status = ItemModel.Status.available
            }
        })
    }
}
//
struct ItemDetailSectionView: View {
    @ObservedObject var itemVM: ItemVM
    var body: some View {
        Section(header: ItemDetailSectionHeaderView(itemVM: itemVM)) {
            TextField("Name", text: $itemVM.nameText)
            TextField("Description", text: $itemVM.description)
            HStack {
                Text("Category").foregroundColor(.secondary)
                Spacer()
                Picker("Category", selection: $itemVM.category) {
                    ForEach(ItemModel.Category.allCases) { Category in
                        ItemCategoryFullNameView(itemCategory: Category).tag(Category)
                    }
                }.pickerStyle(.menu)
            }
            HStack {
                Text("Value").foregroundColor(.secondary)
                Spacer()
                TextField("Value", text: $itemVM.valueText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
        }
    }
}
//
struct ItemDetailSectionHeaderView: View {
    @ObservedObject var itemVM: ItemVM
    var body: some View {
        HStack {
            Text("item")
            Spacer()
            switch itemVM.status {
            case .unknown:
                Text("unknown")
            case .new:
                Text("new")
            case .available:
                Text("available")
            case .unavailable:
                Text("unavailable")
            default:
                Text("")
            }
        }
    }
}
//
struct ItemHistorySectionView: View {
    @ObservedObject var itemVM: ItemVM
    var body: some View {
        Section(header: ItemHistorySectionHeaderView(itemVM: itemVM)) {
            ForEach(itemVM.loanIds.sorted(by: ==), id: \.self) { _ in
                HStack {
                    Text("borrower")
                    Spacer()
                    Text("01/01/2022")
                }
            }
        }
    }
}
//
struct ItemHistorySectionHeaderView: View {
    @ObservedObject var itemVM: ItemVM
    var body: some View {
        HStack {
            Text("borrowed")
            Spacer()
            Text("\(itemVM.loanCount) times")
        }
    }
}
// MARK: - Previews
struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetailView(itemVM: ItemVM())
        }
    }
}
