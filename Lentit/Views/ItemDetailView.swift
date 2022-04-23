//
//  ItemDetailView.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import SwiftUI
// MARK: - Views
struct ItemDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemVM: ItemVM
    @State var editDisabled: Bool = true
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    ItemImageView()
                    ItemDetailSectionView(
                        itemVM: itemVM,
                        editDisabled: editDisabled
                    ).disabled(editDisabled)
                    ItemHistorySectionView(itemVM: itemVM)
                    if(itemVM.status == StatusModel.new) {
                        SaveButtonView(
                            editDisabled: $editDisabled,
                            navigationLinkIsActive: $navigationLinkIsActive,
                            element: .Items,
                            viewModel: itemVM
                        )
                    } else {
                        DeleteButtonView(element: .Items)
                    }
                }
            }
        }.navigationTitle("\(itemVM.name)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(itemVM.status != StatusModel.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
        }
        .alert(isPresented: $appVM.alertPresented) {
            switch appVM.activeAlert {
            case .deleteItem:
                return Alert(
                    title: Text("Delete \(itemVM.name)"),
                    message: Text("Are you sure you want to delete this item ?"),
                    primaryButton: .default(
                        Text("Cancel")
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            navigationLinkIsActive = false // Navigate back to item list
                            appVM.deleteItem(for: itemVM)
                        }
                    )
                )
            default:
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
            }
        }
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
            // Unlock edit mode if item just added
            if(itemVM.status == StatusModel.new) {
                editDisabled = false
            }
        })
        .onChange(of: itemVM.valueText, perform: { _ in
            // Filter unwanted characters & set value text
            itemVM.valueText = itemVM.filterItemValueText(for: itemVM.valueText)
            itemVM.valueText = itemVM.setItemValueText(for: itemVM.valueText)
        })
        .onDisappear(perform: {
            if(itemVM.status == StatusModel.new) {
                itemVM.status = StatusModel.available
            }
        })
    }
}
//
struct ItemDetailSectionView: View {
    @ObservedObject var itemVM: ItemVM
    let editDisabled: Bool
    var body: some View {
        Section(header: ItemDetailSectionHeaderView(itemVM: itemVM)) {
            TextField("Name", text: $itemVM.name).foregroundColor(editDisabled ? .secondary : .primary)
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
                TextField("€", text: $itemVM.valueText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
        }
        Section(header: Text("Notes")) {
            TextEditor(text: $itemVM.notes).foregroundColor(editDisabled ? .secondary : .primary)
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
            StatusNameView(status: itemVM.status)
        }
    }
}
//
struct ItemHistorySectionHeaderView: View {
    @ObservedObject var itemVM: ItemVM
    var body: some View {
        switch itemVM.loanCount {
        case 0:
            EmptyView()
        case 1:
            HStack {
                Text("history")
                Spacer()
                Text("borrowed once")
            }
        default:
            HStack {
                Text("history")
                Spacer()
                Text("borrowed \(itemVM.loanCount) times")
            }
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
                    ItemHistoryItemView(loanVM: appVM.getLoanVM(for: Id))
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
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                Text("\(String(loanVM.loanBorrowerName.prefix(2)))")
                    .font(.headline)
                    .foregroundColor(.white)
            }.padding(.horizontal, 4)
            Text("\(loanVM.loanBorrowerName)")
            Spacer()
            Text("\(loanVM.loanDateText)")
        }
    }
}
// MARK: - Previews
struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //
        NavigationView {
            ItemDetailView(
                itemVM: ItemVM(),
                navigationLinkIsActive: .constant(true)
            ).environmentObject(AppVM())
        }
        //
        List {
            ItemDetailSectionView(
                itemVM: ItemVM(),
                editDisabled: true
            )
        }.previewLayout(.sizeThatFits)
        //
        List {
            ItemHistorySectionView(itemVM: ItemVM())
        }.environmentObject(AppVM())
        .previewLayout(.sizeThatFits)
    }
}
