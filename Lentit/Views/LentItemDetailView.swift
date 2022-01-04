//
//  LentItemDetailView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct LentItemDetailView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    @ObservedObject var lentItemVM: LentItemVM
    @State var editDisabled: Bool = true
    @State var alertPresented: Bool = false
    @State var detailViewPresented: Bool = true
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        VStack {
            if(detailViewPresented) { // Show lent item detail view by default
                Form {
                    LentItemInfoSectionView(
                        lentItemVM: lentItemVM,
                        editDisabled: $editDisabled
                    )
                    LentItemLoanSectionView(
                        lentItemVM: lentItemVM,
                        editDisabled: $editDisabled
                    )
                }.navigationTitle("\(lentItemVM.nameText)")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        LentItemDetailBottomToolbarView(
                            editDisabled: $editDisabled,
                            alertPresented: $alertPresented
                        )
                    }
                }
                .alert(isPresented: $alertPresented) {
                    Alert(
                        title: Text("Delete \(lentItemVM.nameText)"),
                        message: Text("Are you sure you want to delete this item ?"),
                        primaryButton: .default(
                            Text("Cancel")
                        ),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                navigationLinkIsActive = false // Navigate back to lent item list
                                lentItemsListVM.removeLentItem(for: lentItemVM)
                                detailViewPresented = false // Show empty detail view after lent item deleted
                            }
                        )
                    )
                }
                .onAppear(perform: {
                    // Unlock edit mode if lent item just added
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
            } else {
                EmptyView()
            }
        }
    }
}
// MARK: -
struct LentItemInfoSectionView: View {
    @ObservedObject var lentItemVM: LentItemVM
    @Binding var editDisabled: Bool
    var body: some View {
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
    }
}
// MARK: -
struct LentItemLoanSectionView: View {
    @ObservedObject var lentItemVM: LentItemVM
    @Binding var editDisabled: Bool
    let today: Date = Date()
    var body: some View {
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
                    in: ...lentItemVM.lendExpiry,
                    displayedComponents: .date
                ).disabled(editDisabled)
            }
            HStack {
                Text("For").foregroundColor(.secondary)
                Spacer()
                Text("\(lentItemVM.lendTimeText)").italic()
            }
            HStack {
                Text("Due").foregroundColor(.secondary)
                Spacer()
                if(today > lentItemVM.lendExpiry) {
                    Image(systemName: "calendar.badge.exclamationmark").foregroundColor(Color.red)
                }
                DatePicker(
                    "",
                    selection: $lentItemVM.lendExpiry,
                    in: lentItemVM.lendDate...,
                    displayedComponents: .date
                ).disabled(editDisabled)
                .fixedSize()
            }
        }
    }
}
// MARK: -
struct LentItemDetailBottomToolbarView: View {
    @Binding var editDisabled: Bool
    @Binding var alertPresented: Bool
    var body: some View {
        Group {
            // Delete lent item button
            Button {
                alertPresented = true
            } label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }.disabled(editDisabled)
            // Edit lent item button
            Button {
                editDisabled.toggle()
            } label: {
                HStack {
                    Text("Edit")
                    Image(systemName: editDisabled ? "lock" : "lock.open")
                }
            }
        }
    }
}
// MARK: - Previews
struct LentItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LentItemDetailView(
            lentItemVM: LentItemVM(),
            navigationLinkIsActive: .constant(true)
        ).previewLayout(.sizeThatFits)
    }
}
