//
//  NewButtonView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI

struct NewButtonView: View {
    @EnvironmentObject var appVM: AppVM
    let element: AppVM.Element
    var body: some View {
        Button {
            switch element {
            case .Loans:
                appVM.createEmptyLoan()
            case .Borrowers:
                appVM.createEmptyBorrower()
            case .Items:
                appVM.createEmptyItem()
            }
        } label: {
            HStack {
                Spacer()
                Image(systemName: "plus.circle").imageScale(.large)
                switch element {
                case .Loans:
                    Text("New Loan")
                case .Borrowers:
                    Text("New Borrower")
                case .Items:
                    Text("New Item")
                }
                Spacer()
            }.font(.headline)
            .foregroundColor(.white)
            .padding()
        }.background(Color("InvertedAccentColor"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct NewButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NewButtonView(element: AppVM.Element.Loans)
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
    }
}
