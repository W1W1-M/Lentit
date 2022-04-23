//
//  EditButtonView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI
// MARK: - Views
struct EditButtonView: View {
    @Binding var editDisabled: Bool
    var body: some View {
        Button {
            editDisabled.toggle()
        } label: {
            HStack {
                Text(editDisabled ? "Edit" : "Edit")
                Image(systemName: editDisabled ? "lock" : "lock.open")
            }
        }
    }
}
// MARK: - Previews
struct EditButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EditButtonView(editDisabled: .constant(true))
    }
}
