//
//  BorrowerDetailView.swift
//  Lentit
//
//  Created by William Mead on 25/03/2022.
//

import SwiftUI
// MARK: - Views
struct BorrowerDetailView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    @State var editDisabled: Bool = true
    @Binding var navigationLinkIsActive: Bool
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    BorrowerDetailSectionView(
                        borrowerVM: borrowerVM,
                        editDisabled: $editDisabled
                    ).disabled(editDisabled)
                    BorrowerHistorySectionView(borrowerVM: borrowerVM)
                    if(borrowerVM.status == BorrowerModel.Status.new) {
                        SaveButtonView(
                            editDisabled: $editDisabled,
                            navigationLinkIsActive: $navigationLinkIsActive,
                            element: .Borrowers,
                            elementId: borrowerVM.id
                        )
                    } else {
                        DeleteButtonView(element: .Borrowers)
                    }
                }
            }
        }.navigationTitle("\(borrowerVM.nameText)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(borrowerVM.status != BorrowerModel.Status.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
        }
        .alert(isPresented: $appVM.alertPresented) {
            switch appVM.activeAlert {
            case .deleteBorrower:
                return Alert(
                    title: Text("Delete \(borrowerVM.nameText)"),
                    message: Text("Are you sure you want to delete this borrower ?"),
                    primaryButton: .default(
                        Text("Cancel")
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            navigationLinkIsActive = false // Navigate back to borrower list
                            appVM.deleteBorrower(for: borrowerVM)
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
            if(borrowerVM.status == BorrowerModel.Status.new) {
                editDisabled = false
            }
        })
    }
}
// MARK: -
struct BorrowerDetailSectionView: View {
    @ObservedObject var borrowerVM: BorrowerVM
    @Binding var editDisabled: Bool
    var body: some View {
        Section {
            TextField("Name", text: $borrowerVM.nameText).foregroundColor(editDisabled ? .secondary : .primary)
        } header: {
            Text("Borrower")
        }
    }
}
// MARK: -
struct BorrowerHistorySectionView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Section {
            ForEach(borrowerVM.loanIds.sorted(by: ==), id: \.self) { Id in
                BorrowerHistoryItemView(loanVM: appVM.getLoanVM(for: Id))
            }
        } header: {
            switch borrowerVM.loanCount {
            case 0:
                EmptyView()
            case 1:
                HStack {
                    Text("borrowed")
                    Spacer()
                    Text("\(borrowerVM.loanCount) time")
                }
            default:
                HStack {
                    Text("borrowed")
                    Spacer()
                    Text("\(borrowerVM.loanCount) times")
                }
            }
        }
    }
}
// MARK: -
struct BorrowerHistoryItemView: View {
    @ObservedObject var loanVM: LoanVM
    var body: some View {
        HStack {
            Text("\(loanVM.loanItemName)")
            Spacer()
            Text("\(loanVM.loanDateText)")
        }
    }
}
// MARK: - Previews
struct BorrowerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BorrowerDetailView(
                borrowerVM: BorrowerVM(),
                navigationLinkIsActive: .constant(true)
            ).environmentObject(AppVM())
        }
    }
}
