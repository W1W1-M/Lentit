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
    @State var activeAlert: AlertModel = Alerts.deleteLoan
    @State var activeSheet: SheetModel = Sheets.borrowersList
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                LoanItemImageView()
                List {
                    LoanDetailSectionView(
                        loanVM: loanVM,
                        editDisabled: $editDisabled,
                        activeSheet: $activeSheet
                    )
                    if(loanVM.status != LoanModel.Status.finished) {
                        LoanReminderSectionView(
                            loanVM: loanVM,
                            editDisabled: $editDisabled
                        )
                    }
                }.listStyle(.insetGrouped)
                if(loanVM.status == LoanModel.Status.new) {
                    Spacer()
                    SaveNewLoanButtonView(
                        loanVM: loanVM,
                        editDisabled: $editDisabled,
                        navigationLinkIsActive: $navigationLinkIsActive
                    )
                }
            }
        }.navigationTitle(loanVM.borrowerVM.status == BorrowerModel.Status.unknown ? "New loan" : "Loan to \(loanVM.borrowerVM.nameText)")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(loanVM.status != LoanModel.Status.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                if(loanVM.status != LoanModel.Status.new) {
                    LoanDetailDeleteButtonView(
                        editDisabled: editDisabled
                    )
                }
            }
        }
        .alert(isPresented: $appVM.alertPresented) {
            switch activeAlert {
            case Alerts.deleteLoan:
                return Alert(
                    title: Text("Delete \(loanVM.itemVM.nameText) loan"),
                    message: Text("Are you sure you want to delete this loan ?"),
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
        .sheet(isPresented: $appVM.sheetPresented) { [activeSheet] in // Explicit state capture. Fix for known SwiftUI bug.
            switch activeSheet {
            case Sheets.borrowersList:
                BorrowerListSheetView(
                    borrowerListVM: appVM.borrowerListVM,
                    loanVM: loanVM
                )
            case Sheets.itemsList:
                ItemListSheetView(
                    itemListVM: appVM.itemListVM,
                    loanVM: loanVM
                )
            default:
                EmptyView()
            }
        }
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
            // Unlock edit mode if loan just added
            if(loanVM.status == LoanModel.Status.new) {
                editDisabled = false
            }
        })
        .onDisappear(perform: {
            if(loanVM.status == LoanModel.Status.new) {
                loanVM.status = LoanModel.Status.current
            }
            appVM.activeLoanStatus = loanVM.status
        })
    }
}
// MARK: -
struct LoanItemImageView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.accentColor)
            Text("Image")
                .font(.largeTitle)
                .foregroundColor(.white)
        }.padding(.top)
    }
}
// MARK: -
struct LoanDetailSectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @Binding var editDisabled: Bool
    @Binding var activeSheet: SheetModel
    var body: some View {
        Section(header: LoanDetailSectionHeaderView(loanVM: loanVM)) {
            HStack {
                Text("Of").foregroundColor(.secondary)
                Spacer()
                Button {
                    activeSheet = Sheets.itemsList
                    appVM.sheetPresented = true
                } label: {
                    Text(loanVM.itemVM.status == ItemModel.Status.unknown ? "Select item" : "\(loanVM.itemVM.nameText)")
                        .font(.headline)
                        .foregroundColor(editDisabled ? .primary : .accentColor)
                }.disabled(editDisabled)
            }
            HStack {
                Text("To").foregroundColor(.secondary)
                Spacer()
                Button {
                    activeSheet = Sheets.borrowersList
                    appVM.sheetPresented = true
                } label: {
                    Text(loanVM.borrowerVM.status == BorrowerModel.Status.unknown ? "Select borrower" : "\(loanVM.borrowerVM.nameText)")
                        .font(.headline)
                        .italic()
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
                if(editDisabled) {
                    if(loanVM.returned) {
                        Text("Returned").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "checkmark")
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
            }.disabled(loanVM.status == LoanModel.Status.new)
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
            LoanStatusNameView(loanStatus: loanVM.status)
        }.padding(.bottom, 5)
    }
}
// MARK: -
struct LoanReminderSectionView: View {
    @ObservedObject var loanVM: LoanVM
    @Binding var editDisabled: Bool
    var body: some View {
        Section {
            HStack {
                Text("Reminder").foregroundColor(.secondary)
                Spacer()
                if(editDisabled) {
                    if(loanVM.reminderActive) {
                        DatePicker(
                            "",
                            selection: $loanVM.reminder,
                            in: loanVM.loanDate...,
                            displayedComponents: .date
                        ).disabled(editDisabled)
                    } else {
                        Toggle(isOn: $loanVM.reminderActive) {
                            Text("Reminder")
                        }.disabled(editDisabled)
                            .labelsHidden()
                    }
                } else {
                    if(loanVM.reminderActive) {
                        DatePicker(
                            "",
                            selection: $loanVM.reminder,
                            in: loanVM.loanDate...,
                            displayedComponents: .date
                        ).disabled(editDisabled)
                    }
                    Spacer()
                    Toggle(isOn: $loanVM.reminderActive) {
                        Text("Reminder")
                    }.disabled(editDisabled)
                        .labelsHidden()
                }
            }
        }
    }
}
// MARK: -
struct SaveNewLoanButtonView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @Binding var editDisabled: Bool
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        Button {
            editDisabled = true
            loanVM.status = LoanModel.Status.current
            appVM.activeLoanStatus = LoanModel.Status.current
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
        .padding(.horizontal)
    }
}
// MARK: -
struct EditButtonView: View {
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
    @EnvironmentObject var appVM: AppVM
    var editDisabled: Bool
    var body: some View {
        Button {
            appVM.alertPresented = true
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
                navigationLinkIsActive: .constant(false)
            ).environmentObject(AppVM())
        }
        //
        LoanItemImageView().previewLayout(.sizeThatFits)
        //
        LoanDetailSectionView(
            loanVM: LoanVM(),
            editDisabled: .constant(true),
            activeSheet: .constant(Sheets.itemsList)
        ).previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
        //
        SaveNewLoanButtonView(
            loanVM: LoanVM(),
            editDisabled: .constant(true),
            navigationLinkIsActive: .constant(false)
        ).previewLayout(.sizeThatFits)
    }
}
