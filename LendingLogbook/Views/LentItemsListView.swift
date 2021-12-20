//
//  LentItemsListView.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct LentItemsListView: View {
    @ObservedObject var lentItemsStore: LentItemStore
    @State var search: String = ""
    var body: some View {
        Form {
            TextField("Search", text: $search)
            Section(header: HStack {
                Text("\(lentItemsStore.storedItems.count) items")
            }) {
                List {
                    ForEach(lentItemsStore.storedItems) { LentItem in
                        NavigationLink(destination: LentItemDetailView(
                                lentItem: LentItem
                            )
                        ) {
                            LentListItemView(
                                lentItem: LentItem
                            )
                        }
                    }
                }
            }
        }.navigationTitle("Lent items")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
                } label: {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus.circle")
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                            Text("Filter")
                        }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        HStack {
                            Text("Sort")
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                    }
                }
            }
        }
    }
}

struct LentListItemView: View {
    @ObservedObject var lentListItemVM: LentItemVM
    @ObservedObject var lentItem: LentItemModel
    // Custom init
    init(lentItem: LentItemModel) {
        self.lentListItemVM = LentItemVM(lentItem: lentItem)
        self.lentItem = lentItem
    }
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Text("\(lentListItemVM.emojiText) \(lentListItemVM.nameText)").foregroundColor(.primary)
                Spacer()
                Text("\(lentListItemVM.borrowerText)").foregroundColor(.accentColor)
            }
        }
    }
}

struct LentItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                LentItemsListView(
                    lentItemsStore: LentItemStore(itemData: LentItemStore.sampleData)
                )
            }.previewInterfaceOrientation(.landscapeLeft)
        } else {
            NavigationView {
                LentItemsListView(
                    lentItemsStore: LentItemStore(itemData: LentItemStore.sampleData)
                )
            }
        }
        //
        LentListItemView(
            lentItem: LentItemStore.sampleData[0]
        ).previewLayout(.sizeThatFits)
    }
}
