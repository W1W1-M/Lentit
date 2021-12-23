//
//  LentItemDetailView.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct LentItemDetailView: View {
    @ObservedObject var lentItemVM: LentItemVM
    @State var editDisabled: Bool = true
    var body: some View {
        Form {
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
                    Text("\(lentItemVM.lendExpiryText)")
                }
            }
            Section(header: Text("Item")) {
                HStack {
                    Text("\(lentItemVM.emojiText)")
                    TextField("Description", text: $lentItemVM.nameText)
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
                    TextField("Category", text: $lentItemVM.categoryText)
                        .disabled(editDisabled)
                        .multilineTextAlignment(.trailing)
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
        LentItemDetailView(lentItemVM: LentItemVM()).previewLayout(.sizeThatFits)
    }
}
