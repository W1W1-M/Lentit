//
//  ItemStatusNameView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI

struct ItemStatusNameView: View {
    let itemStatus: ItemModel.Status
    var body: some View {
        switch itemStatus {
        case .all:
            Text("all")
        case .new:
            Text("new")
        case .available:
            Text("available")
        case .unavailable:
            Text("unavailable")
        default:
            Text("unknown")
        }
    }
}

struct ItemStatusNameView_Previews: PreviewProvider {
    static var previews: some View {
        ItemStatusNameView(itemStatus: ItemModel.Status.all).previewLayout(.sizeThatFits)
    }
}
