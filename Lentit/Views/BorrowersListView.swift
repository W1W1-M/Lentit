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
    @State var newBorrowerPresented: Bool = false
    @State var newBorrowerName: String = ""
    var body: some View {
        NavigationView {
            List {
                if(newBorrowerPresented) {
                    HStack {
                        TextField("name", text: $newBorrowerName)
                        Spacer()
                        Button {
                            lentItemsListVM.addBorrower(named: newBorrowerName)
                            newBorrowerPresented = false
                        } label: {
                            Text("OK")
                        }
                    }
                }
                ForEach(lentItemsListVM.borrowerVMs) { BorrowerVM in
                    Button {
                        lentItemVM.setLentItemBorrower(to: BorrowerVM)
                        sheetPresented = false
                    } label: {
                        HStack {
                            Text("\(BorrowerVM.nameText)")
                            Spacer()
                            if(lentItemVM.borrowerId == BorrowerVM.id) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }.navigationTitle("Borrowers")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        sheetPresented = false
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        newBorrowerPresented = true
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle")
                        }
                    }
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
