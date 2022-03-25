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
                ItemDetailSectionView(itemVM: itemVM).disabled(editDisabled)
                ItemHistorySectionView(itemVM: itemVM)
            }.listStyle(.insetGrouped)
        }.navigationTitle("\(itemVM.nameText)")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(itemVM.status != ItemModel.Status.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
        }
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
        Section(header: Text("Notes")) {
            TextEditor(text: $itemVM.notes)
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
//
struct ItemHistorySectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemVM: ItemVM
    var body: some View {
        if(itemVM.loanCount > 0) {
            Section(header: ItemHistorySectionHeaderView(itemVM: itemVM)) {
                ForEach(itemVM.loanIds.sorted(by: ==), id: \.self) { Id in
                    ItemHistoryItemView(loanVM: appVM.getLoanVM(with: Id))
                }
            }
        } else {
            EmptyView()
        }
    }
}
//
struct ItemHistoryItemView: View {
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        HStack {
            Text("\(loanVM.borrowerVM.nameText)")
            Spacer()
            Text("\(loanVM.loanDateText)")
        }
    }
}
// MARK: - Previews
struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetailView(itemVM: ItemVM()).environmentObject(AppVM())
        }
    }
}
