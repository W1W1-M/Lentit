//
//  BorrowersListView.swift
//  Lentit
//
//  Created by William Mead on 16/01/2022.
//

import SwiftUI

struct BorrowersListView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    @ObservedObject var lentItemVM: LentItemVM
    @Binding var sheetPresented: Bool
    var body: some View {
        List {
            ForEach(lentItemsListVM.borrowerVMs) { BorrowerVM in
                Button {
                    lentItemVM.setBorrowerId(to: BorrowerVM.id)
                    sheetPresented = false
                } label: {
                    Text("\(BorrowerVM.nameText)")
                }
            }
        }
    }
}

struct BorrowersListView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowersListView(
            lentItemVM: LentItemVM(),
            sheetPresented: .constant(true)
        ).environmentObject(LentItemListVM())
    }
}
