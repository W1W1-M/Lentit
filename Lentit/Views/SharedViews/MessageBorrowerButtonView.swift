//
//  MessageBorrowerButtonView.swift
//  Lentit
//
//  Created by William Mead on 06/05/2022.
//

import SwiftUI

struct MessageBorrowerButtonView: View {
    // MARK: - Properties
    var contactVM: ContactVM
    // MARK: - View
    var body: some View {
        if contactVM.phoneNumbers != nil {
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "message.fill").imageScale(.large)
                    Text("Message \(contactVM.name)")
                    Spacer()
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .listRowBackground(Color("BackgroundColor"))
        } else {
            EmptyView()
        }
    }
}

struct MessageBorrowerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBorrowerButtonView(contactVM: ContactVM())
    }
}
