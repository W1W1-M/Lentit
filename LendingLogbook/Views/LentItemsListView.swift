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
                    ForEach(lentItemsListVM.lentItemStore) { LentItemModel in
                        LentListItemView(lentItemModel: LentItemModel)
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
    @ObservedObject var lentItemModel: LentItemModel
    @StateObject var lentItemVM: LentItemVM = LentItemVM()
    var body: some View {
        NavigationLink(destination: LentItemDetailView(lentItemVM: lentItemVM)) {
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
        .onAppear(perform: {
            // Set lent item view model with lent item data
            lentItemVM.setLentItemVM(for: lentItemModel)
        })
    }
}

struct LentItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LentItemsListView()
        }.environmentObject(LentItemListVM())
        //
        LentListItemView(
            lentItemModel: LentItemStoreModel.sampleData[0]
        ).previewLayout(.sizeThatFits)
    }
}
