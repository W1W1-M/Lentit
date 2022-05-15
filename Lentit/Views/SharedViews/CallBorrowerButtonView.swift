//
//  ContactBorrowerButtonView.swift
//  Lentit
//
//  Created by William Mead on 06/05/2022.
//

import SwiftUI
// MARK: - Views
struct CallBorrowerButtonView: View {
    // MARK: - Properties
    @Environment(\.openURL) private var openURL
    var contactVM: ContactVM
    // MARK: - View
    var body: some View {
        if contactVM.phoneNumbers != nil {
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "phone.fill").imageScale(.large)
                    Text("Call \(contactVM.name)")
                    Spacer()
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .listRowBackground(Color("BackgroundColor"))
        } else {
            EmptyView()
        }
    }
}
// MARK: - Previews
struct ContactBorrowerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CallBorrowerButtonView(contactVM: ContactVM())
    }
}
