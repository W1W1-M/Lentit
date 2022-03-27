//
//  BorrowerDetailView.swift
//  Lentit
//
//  Created by William Mead on 25/03/2022.
//

import SwiftUI

struct BorrowerDetailView: View {
    @ObservedObject var borrowerVM: BorrowerVM
    @State var editDisabled: Bool = true
    var body: some View {
        List {
            Text("")
        }.toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if(borrowerVM.status != BorrowerModel.Status.new) {
                    EditButtonView(editDisabled: $editDisabled)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                if(borrowerVM.status != BorrowerModel.Status.new) {
                    DeleteButtonView(element: .Borrowers)
                }
            }
        }
    }
}

struct BorrowerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowerDetailView(borrowerVM: BorrowerVM())
    }
}
