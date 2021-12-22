//
//  LentItemsListView.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct LentItemsListView: View {
    @EnvironmentObject var lentItemsListVM: LentItemListVM
    @State var search: String = ""
    var body: some View {
        Form {
            TextField("Search", text: $search)
            Section(header: HStack {
                Text("\(lentItemsListVM.lentItemsCountText)")
            }) {
                List {
                    ForEach(lentItemsListVM.lentItemVMs) { LentItemVM in
                        NavigationLink(destination: LentItemDetailView(lentItemVM: LentItemVM)) {
                            LentListItemView(lentItemVM: LentItemVM)
                        }
                    }.onDelete(perform: { IndexSet in
                        lentItemsListVM.lentItemStore.remove(atOffsets: IndexSet)
                    })
                }
            }
        }.navigationTitle("Lent items")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    EditButton()
                    Button {
                        lentItemsListVM.addLentItem()
                    } label: {
                        HStack {
                            Text("Add")
                            Image(systemName: "plus.circle")
                        }
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
    @ObservedObject var lentItemVM: LentItemVM
    var body: some View {
        HStack {
            Button {
                
            } label: {
                HStack {
                    Text("\(lentItemVM.emojiText) \(lentItemVM.nameText)").foregroundColor(.primary)
                    Spacer()
                    Text("\(lentItemVM  .borrowerText)").foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct LentItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LentItemsListView()
        }.environmentObject(LentItemListVM())
        //
        LentListItemView(
            lentItemVM: LentItemVM()
        ).previewLayout(.sizeThatFits)
    }
}
