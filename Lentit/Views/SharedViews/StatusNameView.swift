//
//  StatusNameView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI

struct StatusNameView: View {
    let status: StatusModel
    var body: some View {
        switch status {
        case .all:
            Text("all")
        case .new:
            Text("new")
        case .upcoming:
            Text("upcoming")
        case .current:
            Text("ongoing")
        case .finished:
            Text("finished")
        case .available:
            Text("available")
        case .unavailable:
            Text("unavailable")
        default:
            Text("unknown")
        }
    }
}

struct LoanStatusNameView_Previews: PreviewProvider {
    static var previews: some View {
        StatusNameView(status: StatusModel.current).previewLayout(.sizeThatFits)
    }
}
