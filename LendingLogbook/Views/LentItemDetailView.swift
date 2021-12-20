//
//  LentItemDetailView.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct LentItemDetailView: View {
    @ObservedObject var lentItemVM: LentItemVM
    @ObservedObject var lentItem: LentItemModel
    @State var editDisabled: Bool = true
    // Custom init
    init(lentItem: LentItemModel)  {
        self.lentItemVM = LentItemVM(lentItem: lentItem)
        self.lentItem = lentItem
    }
    var body: some View {
        Form {
            Section(header: Text("Loan")) {
                HStack {
                    Text("To")
                    Spacer()
                    TextField("Borrower", text: $lentItemVM.borrowerText)
                        .disabled(editDisabled)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    DatePicker(
                        "On",
                        selection: $lentItemVM.lendDate,
                        displayedComponents: .date
                    ).disabled(editDisabled)
                }
                HStack {
                    Text("For")
                    Spacer()
                    Text("\(lentItemVM.lendTimeText)")
                }
                HStack {
                    Text("Due")
                    Spacer()
                    Text("\(lentItemVM.lendExpiryText)")
                }
            }
            Section(header: Text("Item")) {
                HStack {
                    Text("\(lentItemVM.emojiText)")
                    TextField("Description", text: $lentItemVM.nameText)
                        .disabled(editDisabled)
                }
                HStack {
                    TextField("Description", text: $lentItemVM.descriptionText)
                        .disabled(editDisabled)
                }
                HStack {
                    Text("Category")
                    Spacer()
                    Text("\(lentItemVM.categoryText)")
                }
                HStack {
                    Text("Value")
                    Spacer()
                    Text("\(lentItemVM.valueText)")
                }
            }
        }.navigationTitle("\(lentItemVM.emojiText) \(lentItemVM.nameText)")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
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
}

struct LentItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LentItemDetailView(
            lentItem: LentItemStore.sampleData[0]
        ).previewLayout(.sizeThatFits)
    }
}
