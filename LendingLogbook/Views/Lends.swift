//
//  Lends.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct Lends: View {
    var lentItems: [LentItem] = [LentItem(), LentItem()]
    @State var search: String = ""
    @State var selectedItemIndex: Int = 0
    var body: some View {
        Form {
            TextField("Search", text: $search)
            Section(header: HStack {
                Text("\(lentItems.count) items")
            }) {
                List {
                    ForEach(lentItems) { LentItem in
                        LentListItem(
                            lentListItem: LentItem,
                            selectedItemIndex: $selectedItemIndex
                        )
                    }
                }
            }
        }.navigationTitle("Lent items")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    EditButton()
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

struct LentListItem: View {
    @ObservedObject var lentListItem: LentItem
    @Binding var selectedItemIndex: Int
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Text("\(lentListItem.emoji) \(lentListItem.name)").foregroundColor(.primary)
                Spacer()
                Text("\(lentListItem.borrower)").foregroundColor(.accentColor)
            }
        }
    }
}

struct Lends_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Lends()
        }
        LentListItem(
            lentListItem: LentItem(),
            selectedItemIndex: .constant(0)
        ).previewLayout(.sizeThatFits)
    }
}
