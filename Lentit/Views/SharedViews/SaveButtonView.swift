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
            editDisabled = true
            navigationLinkIsActive = false
        } label: {
            HStack {
                Spacer()
                Image(systemName: "square.and.arrow.down").imageScale(.large)
                switch element {
                case .Loans:
                    Text("Save Loan")
                case .Borrowers:
                    Text("Save Borrower")
                case .Items:
                    Text("Save Item")
                }
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
