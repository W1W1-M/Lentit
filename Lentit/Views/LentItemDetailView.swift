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
    @State var activeAlert: AlertModel = Alerts.deleteLentItem
    @State var sheetPresented: Bool = false
    @State var activeSheet: SheetModel = Sheets.borrowersList
    @State var detailViewPresented: Bool = true
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        VStack {
            if(detailViewPresented) { // Show lent item detail view by default
                Form {
                    LentItemLoanSectionView(
                        lentItemVM: lentItemVM,
                        editDisabled: $editDisabled,
                        sheetPresented: $sheetPresented,
                        borrowersVMs: lentItemsListVM.borrowerVMs
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
                    switch activeAlert {
                    case Alerts.deleteLentItem:
                        return Alert(
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
                    default:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
                    }
                }
                .sheet(isPresented: $sheetPresented) {
                    switch activeSheet {
                    case Sheets.borrowersList:
                        BorrowersListView(
                            lentItemVM: lentItemVM,
                            sheetPresented: $sheetPresented
                        )
                    default:
                        EmptyView()
                    }
                }
                .onAppear(perform: {
                    // Unlock edit mode if lent item just added
                    if(lentItemVM.justAdded) {
                        lentItemVM.justAdded = false
                        editDisabled = false
                    }
                    print(lentItemVM.borrowerId)
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
struct LentItemLoanSectionView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    @ObservedObject var lentItemVM: LentItemVM
    @Binding var editDisabled: Bool
    @Binding var sheetPresented: Bool
    let borrowersVMs: [BorrowerVM]
    let today: Date = Date()
    var body: some View {
        Section(header: Text("Loan")) {
            HStack {
                TextField("Name", text: $lentItemVM.nameText)
                    .disabled(editDisabled)
                    .font(.headline)
            }
            HStack {
                Text("To").foregroundColor(.secondary)
                Spacer()
                Button {
                    sheetPresented = true
                } label: {
                    Text("\(lentItemVM.borrowerNameText)")
                }.disabled(editDisabled)
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
                Text("Reminder").foregroundColor(.secondary)
            }
            if(editDisabled) {
                if(!lentItemVM.sold) {
                    HStack {
                        if(lentItemVM.returned) {
                            Text("Returned").foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "checkmark")
                        } else {
                            Toggle(isOn: $lentItemVM.returned) {
                                Text("Returned").foregroundColor(.secondary)
                            }.disabled(editDisabled)
                        }
                    }
                }
            } else {
                Toggle(isOn: $lentItemVM.returned) {
                    Text("Returned").foregroundColor(.secondary)
                }.disabled(editDisabled)
            }
            if(editDisabled) {
                if(!lentItemVM.returned) {
                    HStack {
                        if(lentItemVM.sold) {
                            Text("Sold").foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "checkmark")
                        } else {
                            Toggle(isOn: $lentItemVM.sold) {
                                Text("Sold").foregroundColor(.secondary)
                            }.disabled(editDisabled)
                        }
                    }
                }
            } else {
                HStack {
                    Toggle(isOn: $lentItemVM.sold) {
                        Text("Sold").foregroundColor(.secondary)
                    }.disabled(editDisabled)
                }
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
        .environmentObject(LentItemListVM())
    }
}
