//
//  LentItemDetail.swift
//  LendingLogbook
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI

struct LentItemDetail: View {
    @StateObject var lentItem: LentItem = LentItem()
    var body: some View {
        Form {
            HStack {
                Text("To")
                Spacer()
                Text("\(lentItem.borrower)")
            }
            HStack {
                Text("On")
                Spacer()
                Text("\(lentItem.borrowDate)")
            }
            HStack {
                Text("For")
                Spacer()
                Text("\(lentItem.borrowTime)")
            }
        }.navigationTitle("\(lentItem.emoji) \(lentItem.name)")
    }
}

struct LentItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LentItemDetail()
        }
    }
}
