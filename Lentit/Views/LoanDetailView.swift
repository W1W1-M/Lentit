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
    @Binding var navigationLinkIsActive: Bool
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
        }.navigationTitle(loanVM.borrowerVM.status == BorrowerModel.Status.unknown ? "New loan" : "Loan to \(loanVM.borrowerVM.nameText)")
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
                    title: Text("Delete \(loanVM.itemVM.nameText) loan"),
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
                    title: Text("Reminder activated"),
                    message: Text("\(loanVM.itemVM.category.emoji) Loan to \(loanVM.borrowerVM.nameText) added to Apple Reminders"),
                    dismissButton: .default(
                        Text("OK"),
                        action: {
                            
                        }
                    )
                )
            case .reminderNotAdded:
                return Alert(
                    title: Text("Reminder error"),
                    message: Text("Error adding \(loanVM.itemVM.category.emoji) Loan to \(loanVM.borrowerVM.nameText) to Apple Reminders"),
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
                    Text(loanVM.itemVM.status == ItemModel.Status.unknown ? "Select item" : "\(loanVM.itemVM.nameText)")
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
                    if(loanVM.reminderVM.reminderActive) {
                        Text("\(loanVM.reminderVM.reminderDateText)")
                    } else {
                        Toggle(isOn: $loanVM.reminderVM.reminderActive) {
                            Text("Reminder")
                        }.disabled(editDisabled)
                            .labelsHidden()
                    }
                } else {
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
        DatePicker(
            "Date",
            selection: $loanVM.reminderVM.reminderDate,
            in: loanVM.loanDate...,
            displayedComponents: .date
        )
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
        Button {
            do {
                try loanVM.reminderVM.deleteReminder(oldReminder: loanVM.reminderVM.ekReminder)
            } catch {
                // alert reminder delete error
            }
        } label: {
            HStack {
                Spacer()
                Image(systemName: "minus.circle").imageScale(.large)
                Text("Delete reminder")
                Spacer()
            }
        }.foregroundColor(.white)
        .listRowBackground(Color.red)
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
            editDisabled: .constant(true)
        ).previewLayout(.sizeThatFits)
        .environmentObject(AppVM())
        //
        Form {
            LoanReminderDetailView(loanVM: LoanVM()).previewLayout(.sizeThatFits)
        }
    }
}
