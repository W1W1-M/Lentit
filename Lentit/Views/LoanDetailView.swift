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
    @Binding var navigationLinkIsActive: Bool
    @State var editDisabled: Bool = true
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            Form {
                ItemImageView()
                LoanDetailSectionView(
                    loanVM: loanVM,
                    editDisabled: $editDisabled
                )
                if(loanVM.status != LoanModel.Status.finished) {
                    LoanReminderSectionView(
                        loanVM: loanVM,
                        editDisabled: $editDisabled
                    )
                }
                if(loanVM.status == LoanModel.Status.new) {
                    SaveButtonView(
                        editDisabled: $editDisabled,
                        navigationLinkIsActive: $navigationLinkIsActive,
                        element: .Loans,
                        elementId: loanVM.id
                    )
                } else {
                    DeleteButtonView(element: .Loans)
                }
            }
        }.navigationTitle(loanVM.loanBorrower.status == BorrowerModel.Status.unknown ? "New loan" : "Loan to \(loanVM.loanBorrowerName)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(loanVM.status != LoanModel.Status.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
        }
        .alert(isPresented: $appVM.alertPresented) {
            switch appVM.activeAlert {
            case .deleteLoan:
                return Alert(
                    title: Text("Delete \(loanVM.loanItemName) loan"),
                    message: Text("Are you sure you want to delete this loan ?"),
                    primaryButton: .default(
                        Text("Cancel")
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            navigationLinkIsActive = false // Navigate back to loan list
                            appVM.deleteLoan(for: loanVM)
                        }
                    )
                )
            case .reminderAdded:
                return Alert(
                    title: Text("Reminder added"),
                    message: Text("\(loanVM.loanItemCategory.emoji) Loan to \(loanVM.loanBorrowerName) added to Apple Reminders"),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            
                        }
                    )
                )
            case .reminderNotAdded:
                return Alert(
                    title: Text("Reminder error"),
                    message: Text("Error adding \(loanVM.loanItemCategory.emoji) Loan to \(loanVM.loanBorrowerName) to Apple Reminders. Please check Lentit has access to Reminders in iOS Privacy settings."),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            
                        }
                    )
                )
            case .reminderDeleted:
                return Alert(
                    title: Text("Reminder deleted"),
                    message: Text("\(loanVM.loanItemCategory.emoji) Loan to \(loanVM.loanBorrowerName) deleted from Apple Reminders"),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            
                        }
                    )
                )
            case .reminderNotDeleted:
                return Alert(
                    title: Text("Reminder error"),
                    message: Text("Error deleting \(loanVM.loanItemCategory.emoji) Loan to \(loanVM.loanBorrowerName) to Apple Reminders. Please check Lentit has access to Reminders in iOS Privacy settings."),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            
                        }
                    )
                )
            default:
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
            }
        }
        .sheet(isPresented: $appVM.sheetPresented) {
            switch appVM.activeSheet {
            case .borrowersList:
                BorrowerListSheetView(
                    borrowerListVM: appVM.borrowerListVM,
                    loanVM: loanVM
                )
            case .itemsList:
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
struct LoanDetailSectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @Binding var editDisabled: Bool
    var body: some View {
        Section(header: LoanDetailSectionHeaderView(loanVM: loanVM)) {
            HStack {
                Text("Of").foregroundColor(.secondary)
                Spacer()
                Button {
                    appVM.activeSheet = .itemsList
                    appVM.sheetPresented = true
                } label: {
                    Text(loanVM.loanItem.status == ItemModel.Status.unknown ? "Select item" : "\(loanVM.loanItemName)")
                        .font(.headline)
                        .foregroundColor(editDisabled ? .primary : .accentColor)
                }.disabled(editDisabled)
            }
            HStack {
                Text("To").foregroundColor(.secondary)
                Spacer()
                Button {
                    appVM.activeSheet = .borrowersList
                    appVM.sheetPresented = true
                } label: {
                    Text(loanVM.loanBorrower.status == BorrowerModel.Status.unknown ? "Select borrower" : "\(loanVM.loanBorrowerName)")
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
                    if(loanVM.reminderVM.reminderActive) {
                        Text("\(loanVM.reminderVM.reminderDateText)")
                    } else {
                        Toggle(isOn: $loanVM.reminderVM.reminderActive) {
                            Text("Reminder")
                        }.disabled(editDisabled)
                            .labelsHidden()
                    }
                } else {
                    DatePicker(
                        "",
                        selection: $loanVM.reminderVM.reminderDate,
                        in: loanVM.loanDate...,
                        displayedComponents: .date
                    )
                    Spacer()
                    Toggle(isOn: $loanVM.reminderVM.reminderActive) {
                        Text("Reminder")
                    }.disabled(editDisabled)
                    .labelsHidden()
                }
            }
            if(!editDisabled && loanVM.reminderVM.reminderActive) {
                LoanReminderDetailView(loanVM: loanVM).disabled(editDisabled)
            }
        }
    }
}
struct LoanReminderDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        if(loanVM.reminderVM.ekReminderExists) {
            Button {
                do {
                    try loanVM.reminderVM.deleteReminder()
                    appVM.activeAlert = .reminderDeleted
                } catch {
                    appVM.activeAlert = .reminderNotDeleted
                }
                appVM.alertPresented = true
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "minus.circle").imageScale(.large)
                    Text("Delete reminder")
                    Spacer()
                }
            }.foregroundColor(.white)
            .listRowBackground(Color.red)
        } else {
            Button {
                do {
                    try loanVM.reminderVM.createReminder()
                    appVM.activeAlert = .reminderAdded
                } catch {
                    appVM.activeAlert = .reminderNotAdded
                }
                appVM.alertPresented = true
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle").imageScale(.large)
                    Text("Add reminder")
                    Spacer()
                }
            }.foregroundColor(.white)
            .listRowBackground(Color.green)
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
        ItemImageView().previewLayout(.sizeThatFits)
        //
        LoanDetailSectionView(
            loanVM: LoanVM(),
            editDisabled: .constant(false)
        ).previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
        //
        Form {
            LoanReminderDetailView(loanVM: LoanVM())
        }.previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
    }
}
