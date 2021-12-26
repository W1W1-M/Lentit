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
                        LentListItemView(
                            lentItemVM: LentItemVM
                        )
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
    @State var navigationLinkIsActive: Bool = false
    var body: some View {
        NavigationLink(
            destination: LentItemDetailView(lentItemVM: lentItemVM),
            isActive: $navigationLinkIsActive
        ) {
            HStack {
                Button {
                    
                } label: {
                    HStack {
                        Text(" \(lentItemVM.nameText)").foregroundColor(.primary)
                        Spacer()
                        Text("\(lentItemVM.borrowerText)").foregroundColor(.accentColor)
                    }
                }
            }
        }
        .onAppear(perform: {
            // Navigation to newly added item
            if(lentItemVM.justAdded) {
                navigationLinkIsActive = true
            }
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
            lentItemVM: LentItemVM()
        ).previewLayout(.sizeThatFits)
    }
}
