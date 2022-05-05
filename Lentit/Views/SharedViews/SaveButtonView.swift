//
//  SaveButtonView.swift
//  Lentit
//
//  Created by William Mead on 28/03/2022.
//

import SwiftUI

struct SaveButtonView<VMT: ViewModelProtocol>: View {
    @EnvironmentObject var appVM: AppVM
    let element: AppVM.Element
    @ObservedObject var viewModel: VMT
    var body: some View {
        Button {
            switch element {
            case .Loans:
                viewModel.status = .current
                appVM.activeLoanStatus = .current
            case .Items:
                viewModel.status = .available
                appVM.activeItemStatus = .all
            case .Borrowers:
                viewModel.status = .regular
                appVM.activeBorrowerStatus = .all
            }
            viewModel.updateModel()
            viewModel.editDisabled = true
            viewModel.navigationLinkActive = false
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
            element: .Loans,
            viewModel: LoanVM()
        ).previewLayout(.sizeThatFits)
    }
}
