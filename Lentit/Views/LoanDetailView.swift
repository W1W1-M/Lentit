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
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    LoanDetailSectionView(
                        loanVM: loanVM,
                        editDisabled: $editDisabled,
                        sheetPresented: $sheetPresented,
                        activeSheet: $activeSheet
                    )
                }.listStyle(.plain)
                if(loanVM.status == LoanStatus.new) {
                    Spacer()
                    SaveNewLoanButtonView(
                        loanVM: loanVM,
                        navigationLinkIsActive: $navigationLinkIsActive
                    )
                }
            }
        }.navigationTitle(loanVM.itemVM.status == ItemStatus.unknown ? "New loan" : "\(loanVM.itemVM.nameText)")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(loanVM.status != LoanStatus.new) {
                    LoanDetailEditButtonView(editDisabled: $editDisabled)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                if(loanVM.status != LoanStatus.new) {
                    LoanDetailDeleteButtonView(
                        alertPresented: $alertPresented,
                        editDisabled: editDisabled
                    )
                }
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
                editDisabled = false
            }
        })
        .onDisappear(perform: {
            if(loanVM.status == LoanStatus.new) {
                loanVM.status = LoanStatus.current
            }
            appVM.activeStatus = loanVM.status
        })
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
                    Text(loanVM.itemVM.status == ItemStatus.unknown ? "Select item" : "\(loanVM.itemVM.nameText)")
                        .font(.headline)
                        .foregroundColor(editDisabled ? .primary : .accentColor)
                }.disabled(editDisabled)
            }
            HStack {
                Text("To").foregroundColor(.secondary)
                Spacer()
                Button {
                    activeSheet = Sheets.borrowersList
                    sheetPresented = true
                } label: {
                    Text(loanVM.borrowerVM.status == BorrowerStatus.unknown ? "Select borrower" : "\(loanVM.borrowerVM.nameText)")
                        .font(.headline)
                        .foregroundColor(editDisabled ? .primary : .accentColor)
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
                if(loanVM.returned) {
                    HStack {
                        Text("Returned").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                } else {
                    Toggle(isOn: $loanVM.returned) {
                        Text("Returned").foregroundColor(.secondary)
                    }.disabled(editDisabled)
                }
            } else {
                Toggle(isOn: $loanVM.returned) {
                    Text("Returned").foregroundColor(.secondary)
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
        }.padding(.bottom, 5)
    }
}
// MARK: -
struct SaveNewLoanButtonView: View {
    @ObservedObject var loanVM: LoanVM
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        Button {
            loanVM.status = LoanStatus.current
            navigationLinkIsActive = false
        } label: {
            HStack {
                Spacer()
                Image(systemName: "plus.circle").imageScale(.large)
                Text("Save new loan")
                Spacer()
            }.font(.headline)
            .foregroundColor(.white)
            .padding()
        }.background(Color("InvertedAccentColor"))
        .clipShape(Capsule())
        .padding()
    }
}
// MARK: -
struct LoanDetailEditButtonView: View {
    @Binding var editDisabled: Bool
    var body: some View {
        Button {
            editDisabled.toggle()
        } label: {
            HStack {
                Text(editDisabled ? "Edit" : "Save")
                Image(systemName: editDisabled ? "lock" : "lock.open")
            }
        }
    }
}
// MARK: -
struct LoanDetailDeleteButtonView: View {
    @Binding var alertPresented: Bool
    var editDisabled: Bool
    var body: some View {
        Button {
            alertPresented = true
        } label: {
            HStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
}
// MARK: - Previews
struct LoanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoanDetailView(
                loanVM: LoanVM(),
                navigationLinkIsActive: .constant(true)
            ).environmentObject(AppVM())
        }
        //
        LoanDetailView(
            loanVM: LoanVM(),
            navigationLinkIsActive: .constant(true)
        ).previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
        //
        SaveNewLoanButtonView(
            loanVM: LoanVM(),
            navigationLinkIsActive: .constant(false)
        ).previewLayout(.sizeThatFits)
    }
}
