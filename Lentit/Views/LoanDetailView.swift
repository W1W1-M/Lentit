//
//  LoanDetailView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct LoanDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @State var editDisabled: Bool = true
    @State var alertPresented: Bool = false
    @State var activeAlert: AlertModel = Alerts.deleteLentItem
    @State var sheetPresented: Bool = false
    @State var activeSheet: SheetModel = Sheets.borrowersList
    @State var detailViewPresented: Bool = true
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        VStack {
            if(detailViewPresented) { // Show loan detail view by default
                Form {
                    LoanDetailSectionView(
                        loanVM: loanVM,
                        editDisabled: $editDisabled,
                        sheetPresented: $sheetPresented,
                        activeSheet: $activeSheet
                    )
                }.navigationTitle("\(loanVM.itemVM.nameText)")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        LoanDetailBottomToolbarView(
                            editDisabled: $editDisabled,
                            alertPresented: $alertPresented
                        )
                    }
                }
                .alert(isPresented: $alertPresented) {
                    switch activeAlert {
                    case Alerts.deleteLentItem:
                        return Alert(
                            title: Text("Delete \(loanVM.itemVM.nameText)"),
                            message: Text("Are you sure you want to delete this item ?"),
                            primaryButton: .default(
                                Text("Cancel")
                            ),
                            secondaryButton: .destructive(
                                Text("Delete"),
                                action: {
                                    navigationLinkIsActive = false // Navigate back to lent item list
                                    appVM.deleteLoan(for: loanVM)
                                    detailViewPresented = false // Show empty detail view after lent item deleted
                                }
                            )
                        )
                    default:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
                    }
                }
                .sheet(isPresented: $sheetPresented) { [activeSheet] in // Explicit state capture. Fix for known SwiftUI bug.
                    switch activeSheet {
                    case Sheets.borrowersList:
                        BorrowerListView(
                            borrowerListVM: appVM.borrowerListVM,
                            loanVM: loanVM,
                            sheetPresented: $sheetPresented
                        )
                    case Sheets.itemsList:
                        ItemListView(
                            itemListVM: appVM.itemListVM,
                            loanVM: loanVM,
                            sheetPresented: $sheetPresented
                        )
                    default:
                        EmptyView()
                    }
                }
                .onAppear(perform: {
                    // Unlock edit mode if loan just added
                    if(loanVM.status == LoanStatus.new) {
                        loanVM.status = LoanStatus.current
                        editDisabled = false
                    }
                })
                .onDisappear(perform: {
                    appVM.activeStatus = loanVM.status
                })
            } else {
                EmptyView()
            }
        }
    }
}
// MARK: -
struct LoanDetailSectionView: View {
    @ObservedObject var loanVM: LoanVM
    @Binding var editDisabled: Bool
    @Binding var sheetPresented: Bool
    @Binding var activeSheet: SheetModel
    var body: some View {
        Section(header: LoanDetailSectionHeaderView(loanVM: loanVM)) {
            HStack {
                Text("Of").foregroundColor(.secondary)
                Spacer()
                Button {
                    activeSheet = Sheets.itemsList
                    sheetPresented = true
                } label: {
                    Text("\(loanVM.itemVM.nameText)").font(.headline)
                }.disabled(editDisabled)
            }
            HStack {
                Text("To").foregroundColor(.secondary)
                Spacer()
                Button {
                    activeSheet = Sheets.borrowersList
                    sheetPresented = true
                } label: {
                    Text("\(loanVM.borrowerVM.nameText)")
                }.disabled(editDisabled)
            }
            HStack {
                Text("On").foregroundColor(.secondary)
                DatePicker(
                    "",
                    selection: $loanVM.loanDate,
                    displayedComponents: .date
                ).disabled(editDisabled)
            }
            HStack {
                Text("Reminder").foregroundColor(.secondary)
                DatePicker(
                    "",
                    selection: $loanVM.reminder,
                    in: loanVM.loanDate...,
                    displayedComponents: .date
                ).disabled(editDisabled)
            }
            if(editDisabled) {
                if(loanVM.returnedSold) {
                    HStack {
                        Text("Returned / Sold").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                } else {
                    Toggle(isOn: $loanVM.returnedSold) {
                        Text("Returned / Sold").foregroundColor(.secondary)
                    }.disabled(editDisabled)
                }
            } else {
                Toggle(isOn: $loanVM.returnedSold) {
                    Text("Returned / Sold").foregroundColor(.secondary)
                }.disabled(editDisabled)
            }
        }
    }
}
// MARK: -
struct LoanDetailSectionHeaderView: View {
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        HStack {
            Text("Loan")
            Spacer()
            Text(LocalizedStringKey(loanVM.status.name))
        }
    }
}
// MARK: -
struct LoanDetailBottomToolbarView: View {
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
struct LoanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LoanDetailView(
            loanVM: LoanVM(),
            navigationLinkIsActive: .constant(true)
        ).previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
    }
}
