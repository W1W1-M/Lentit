//
//  ItemListView.swift
//  Lentit
//
//  Created by William Mead on 21/01/2022.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var itemListVM: ItemListVM
    @ObservedObject var loanVM: LoanVM
    @Binding var sheetPresented: Bool
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("\(itemListVM.itemsCountText) items")) {
                    ForEach(appVM.itemVMs) { ItemVM in
                        Button {
                            loanVM.setLoanItem(to: ItemVM)
                            sheetPresented = false
                        } label: {
                            HStack {
                                Text("\(ItemVM.nameText)")
                                Spacer()
                                if(loanVM.itemVM.id == ItemVM.id) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("Items")
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
                        // WIP
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

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(
            itemListVM: ItemListVM(),
            loanVM: LoanVM(),
            sheetPresented: .constant(true)
        ).environmentObject(AppVM())
    }
}
