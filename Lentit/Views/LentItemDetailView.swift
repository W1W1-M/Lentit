//
//  LentItemDetailView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct LentItemDetailView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    @ObservedObject var lentItemVM: LentItemVM
    @State var editDisabled: Bool = true
    @Binding var navigationLinkIsActive: Bool
    let today: Date = Date()
    var body: some View {
        Form {
            Section(header: Text("Item")) {
                HStack {
                    TextField("Name", text: $lentItemVM.nameText)
                        .disabled(editDisabled)
                        .font(.headline)
                }
                HStack {
                    TextField("Description", text: $lentItemVM.descriptionText)
                        .disabled(editDisabled)
                }
                HStack {
                    Text("Category").foregroundColor(.secondary)
                    Spacer()
                    Picker("Category", selection: $lentItemVM.category) {
                        ForEach(LentItemCategories.categories) { LentItemCategoryModel in
                            Text("\(LentItemCategoryModel.name)").tag(LentItemCategoryModel)
                        }
                    }.pickerStyle(.menu)
                    .disabled(editDisabled)
                }
                HStack {
                    Text("Value").foregroundColor(.secondary)
                    Spacer()
                    TextField("Value", text: $lentItemVM.valueText)
                        .disabled(editDisabled)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
            }
            Section(header: Text("Loan")) {
                HStack {
                    Text("To").foregroundColor(.secondary)
                    Spacer()
                    TextField("Borrower", text: $lentItemVM.borrowerText)
                        .disabled(editDisabled)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("On").foregroundColor(.secondary)
                    DatePicker(
                        "",
                        selection: $lentItemVM.lendDate,
                        displayedComponents: .date
                    ).disabled(editDisabled)
                }
                HStack {
                    Text("For").foregroundColor(.secondary)
                    Spacer()
                    Text("\(lentItemVM.lendTimeText)").italic()
                }
                HStack {
                    if(today > lentItemVM.lendExpiry) {
                        Text("Due").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "calendar.badge.exclamationmark").foregroundColor(Color.red)
                        Spacer()
                        DatePicker(
                            "",
                            selection: $lentItemVM.lendExpiry,
                            displayedComponents: .date
                        ).disabled(editDisabled)
                    } else {
                        Text("Due").foregroundColor(.secondary)
                        Spacer()
                        DatePicker(
                            "",
                            selection: $lentItemVM.lendExpiry,
                            displayedComponents: .date
                        ).disabled(editDisabled)
                    }
                    
                }
            }
        }.navigationTitle("\(lentItemVM.nameText)")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Group {
                    Button {
                        editDisabled.toggle()
                    } label: {
                        HStack {
                            Text("Edit")
                            Image(systemName: editDisabled ? "lock" : "lock.open")
                        }
                    }
                    Button {
                        navigationLinkIsActive = false
                        lentItemsListVM.removeLentItem(for: lentItemVM)
                    } label: {
                        HStack {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }.disabled(editDisabled)
                }
            }
        }
        .onAppear(perform: {
            // Unlock lent item edit mode if just added
            if(lentItemVM.justAdded) {
                lentItemVM.justAdded = false
                editDisabled = false
            }
        })
        .onChange(of: lentItemVM.valueText, perform: { _ in
            // Filter unwanted characters & set value text
            lentItemVM.valueText = lentItemVM.filterLentItemValueText(for: lentItemVM.valueText)
            lentItemVM.valueText = lentItemVM.setLentItemValueText(for: lentItemVM.lentItem.value)
        })
    }
}

struct LentItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LentItemDetailView(
            lentItemVM: LentItemVM(),
            navigationLinkIsActive: .constant(true)
        ).previewLayout(.sizeThatFits)
    }
}
