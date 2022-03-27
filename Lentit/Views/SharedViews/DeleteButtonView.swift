//
//  DeleteButtonView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI
// MARK: - Views
struct DeleteButtonView: View {
    @EnvironmentObject var appVM: AppVM
    let element: AppVM.Element
    var body: some View {
        Button {
            switch element {
            case .Loans:
                appVM.activeAlert = .deleteLoan
            case .Borrowers:
                appVM.activeAlert = .deleteBorrower
            case .Items:
                appVM.activeAlert = .deleteItem
            }
            appVM.alertPresented = true
        } label: {
            HStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
}
// MARK: - Previews
struct DeleteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButtonView(element: .Loans)
    }
}
