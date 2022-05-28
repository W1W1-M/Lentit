//
//  LoanDetailView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
import EventKit
// MARK: - Views
struct LoanDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            Form {
                CircleImageView()
                LoanDetailSectionView(loanVM: loanVM)
                if(loanVM.status != StatusModel.finished) {
                    LoanReminderSectionView(
                        loanVM: loanVM,
                        remindersVM: appVM.getRemindersVM(for: loanVM.model)
                    )
                }
                if(loanVM.status == StatusModel.new) {
                    SaveButtonView(
                        element: .Loans,
                        viewModel: loanVM
                    )
                }
            }
        }.navigationTitle(loanVM.loanBorrower.status == StatusModel.unknown ? "New loan" : "Loan to \(loanVM.loanBorrowerName)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(loanVM.status != StatusModel.new) {
                    EditButtonView(editDisabled: $loanVM.editDisabled)
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    appVM.activeAlert = .deleteLoan
                    appVM.alertPresented = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Loan")
                    }
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
                            loanVM.navigationLinkActive = false // Navigate back to loan list
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
                    message: Text("Error adding \(loanVM.loanItemCategory.emoji) Loan to \(loanVM.loanBorrowerName) to Apple Reminders"),
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
                    message: Text("Error deleting \(loanVM.loanItemCategory.emoji) Loan to \(loanVM.loanBorrowerName) to Apple Reminders"),
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
            case .contactsList:
                EmptyView()
            case .borrowerDetail:
                BorrowerDetailSheetView(
                    borrowerVM: appVM.getBorrowerVM(for: loanVM.loanBorrower.id),
                    contactsVM: ContactsVM(
                        contactsStore: appVM.contactsStore,
                        contactsAccess: appVM.contactsAccess
                    )
                )
            case .itemDetail:
                ItemDetailSheetView(itemVM: appVM.getItemVM(for: loanVM.loanItem.id))
            }
        }
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
            // Unlock edit mode if loan just added
            if(loanVM.status == StatusModel.new) {
                loanVM.editDisabled = false
            }
        })
        .onDisappear(perform: {
            appVM.activeLoanStatus = loanVM.status
        })
    }
}
// MARK: -
struct LoanDetailSectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        Section(header: LoanDetailSectionHeaderView(loanVM: loanVM)) {
            HStack {
                Text("Of").foregroundColor(.secondary)
                Spacer()
                if loanVM.editDisabled {
                    Button {
                        appVM.activeSheet = .itemDetail
                        appVM.sheetPresented = true
                    } label: {
                        HStack {
                            Text(loanVM.loanItem.status == StatusModel.unknown ? "Select item" : "\(loanVM.loanItemName)")
                                .font(.headline)
                            .foregroundColor(loanVM.editDisabled ? .primary : .accentColor)
                            Image(systemName: "info.circle").imageScale(.large)
                        }
                    }
                } else {
                    Button {
                        appVM.activeSheet = .itemsList
                        appVM.sheetPresented = true
                    } label: {
                        HStack {
                            Text(loanVM.loanItem.status == StatusModel.unknown ? "Select item" : "\(loanVM.loanItemName)")
                                .font(.headline)
                            .foregroundColor(loanVM.editDisabled ? .primary : .accentColor)
                            Image(systemName: "archivebox.circle.fill").imageScale(.large)
                        }
                    }
                }
            }
            HStack {
                Text("To").foregroundColor(.secondary)
                Spacer()
                if loanVM.editDisabled {
                    Button {
                        appVM.activeSheet = .borrowerDetail
                        appVM.sheetPresented = true
                    } label: {
                        HStack {
                            Text(loanVM.loanBorrower.status == StatusModel.unknown ? "Select borrower" : "\(loanVM.loanBorrowerName)")
                                .font(.headline)
                                .italic()
                            .foregroundColor(loanVM.editDisabled ? .primary : .accentColor)
                            Image(systemName: "info.circle").imageScale(.large)
                        }
                    }
                } else  {
                    Button {
                        appVM.activeSheet = .borrowersList
                        appVM.sheetPresented = true
                    } label: {
                        HStack {
                            Text(loanVM.loanBorrower.status == StatusModel.unknown ? "Select borrower" : "\(loanVM.loanBorrowerName)")
                                .font(.headline)
                                .italic()
                            .foregroundColor(loanVM.editDisabled ? .primary : .accentColor)
                            Image(systemName: "person.circle.fill").imageScale(.large)
                        }
                    }
                }
            }
            HStack {
                Text("On").foregroundColor(.secondary)
                DatePicker(
                    "",
                    selection: $loanVM.loanDate,
                    displayedComponents: .date
                ).disabled(loanVM.editDisabled)
            }
            HStack {
                if(loanVM.editDisabled) {
                    if(loanVM.returned) {
                        Text("Returned").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "checkmark")
                    } else {
                        Toggle(isOn: $loanVM.returned) {
                            Text("Returned").foregroundColor(.secondary)
                        }.disabled(loanVM.editDisabled)
                    }
                } else {
                    Toggle(isOn: $loanVM.returned) {
                        Text("Returned").foregroundColor(.secondary)
                    }.disabled(loanVM.editDisabled)
                }
            }.disabled(loanVM.status == StatusModel.new)
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
            StatusNameView(status: loanVM.status)
        }.padding(.bottom, 5)
    }
}
// MARK: -
struct LoanReminderSectionView: View {
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var remindersVM: RemindersVM
    var body: some View {
        Section {
            HStack {
                Text("Reminder (iOS)").foregroundColor(.secondary)
                if(loanVM.editDisabled) {
                    if(remindersVM.reminderActive) {
                        if(remindersVM.ekReminderExists) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        } else {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                        Spacer()
                        Text("\(remindersVM.reminderDateText)")
                    } else {
                        Spacer()
                        Toggle(isOn: $remindersVM.reminderActive) {
                            Text("Reminder")
                        }.disabled(loanVM.editDisabled)
                        .labelsHidden()
                    }
                } else {
                    if(remindersVM.ekReminderExists) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    } else {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                    Spacer()
                    Toggle(isOn: $remindersVM.reminderActive) {
                        Text("Reminder")
                    }.disabled(loanVM.editDisabled)
                    .labelsHidden()
                }
            }
            if(!loanVM.editDisabled && remindersVM.reminderActive) {
                LoanReminderDetailView(
                    loanVM: loanVM,
                    remindersVM: remindersVM
                ).disabled(loanVM.editDisabled)
            }
        }
    }
}
struct LoanReminderDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var loanVM: LoanVM
    @ObservedObject var remindersVM: RemindersVM
    var body: some View {
        DatePicker(
            "Date",
            selection: $remindersVM.reminderDate,
            in: loanVM.loanDate...,
            displayedComponents: .date
        ).foregroundColor(.secondary)
        if(remindersVM.ekReminderExists) {
            Button {
                do {
                    try remindersVM.deleteReminder()
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
                    try remindersVM.createReminder()
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
            LoanDetailView(loanVM: LoanVM()).environmentObject(AppVM())
        }
        //
        CircleImageView().previewLayout(.sizeThatFits)
        //
        LoanDetailSectionView(loanVM: LoanVM()).previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
        //
        Form {
            LoanReminderDetailView(
                loanVM: LoanVM(),
                remindersVM: RemindersVM(
                    loan: LoanModel.defaultData,
                    reminderTitle: "",
                    reminderNotes: "",
                    eventStore: EKEventStore(),
                    reminderAccess: .notDetermined,
                    reminderDefaultCalendar: EKCalendar(for: .reminder, eventStore: EKEventStore())
                )
            )
        }.previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
    }
}
