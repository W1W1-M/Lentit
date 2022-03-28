//
//  SaveButtonView.swift
//  Lentit
//
//  Created by William Mead on 28/03/2022.
//

import SwiftUI

struct SaveButtonView: View {
    @EnvironmentObject var appVM: AppVM
    @Binding var editDisabled: Bool
    @Binding var navigationLinkIsActive: Bool
    let element: AppVM.Element
    let elementId: UUID
    var body: some View {
        Button {
            switch element {
            case .Loans:
                let loanVM = appVM.getLoanVM(with: elementId)
                loanVM.status = .current
                appVM.activeLoanStatus = .current
            case .Borrowers:
                let borrowerVM = appVM.getBorrowerVM(with: elementId)
                borrowerVM.status = .regular
                appVM.activeBorrowerStatus = .regular
            case .Items:
                let itemVM = appVM.getItem(with: elementId)
                itemVM.status = .available
                appVM.activeItemStatus = .available
            }
            editDisabled = true
            navigationLinkIsActive = false
        } label: {
            HStack {
                Spacer()
                Image(systemName: "square.and.arrow.down").imageScale(.large)
                Text("Save")
                Spacer()
            }
        }.font(.headline)
        .foregroundColor(.white)
        .padding()
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .listRowBackground(Color("BackgroundColor"))
    }
}

struct SaveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SaveButtonView(
            editDisabled: .constant(false),
            navigationLinkIsActive: .constant(false),
            element: .Loans,
            elementId: UUID()
        ).previewLayout(.sizeThatFits)
    }
}
