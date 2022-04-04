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
                Spacer()
                Image(systemName: "trash").imageScale(.large)
                switch element {
                case .Loans:
                    Text("Delete Loan")
                case .Borrowers:
                    Text("Delete Borrower")
                case .Items:
                    Text("Delete Item")
                }
                Spacer()
            }
        }.font(.headline)
        .foregroundColor(.white)
        .padding()
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .listRowBackground(Color("BackgroundColor"))
    }
}
// MARK: - Previews
struct DeleteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButtonView(element: .Loans).previewLayout(.sizeThatFits)
    }
}
