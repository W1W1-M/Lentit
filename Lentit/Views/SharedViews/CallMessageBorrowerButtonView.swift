//
//  ContactBorrowerButtonView.swift
//  Lentit
//
//  Created by William Mead on 06/05/2022.
//

import SwiftUI
// MARK: - Views
struct CallMessageBorrowerButtonView: View {
    // MARK: - Properties
    var contactVM: ContactVM
    // MARK: - View
    var body: some View {
        Menu {
            if contactVM.phoneNumbers != nil {
                Link(destination: contactVM.phoneURL!) {
                    HStack {
                        Spacer()
                        Image(systemName: "phone.fill").imageScale(.large)
                        Text("Call \(contactVM.name)")
                        Spacer()
                    }
                }
                Link(destination: contactVM.messageURL!) {
                    HStack {
                        Spacer()
                        Image(systemName: "message.fill").imageScale(.large)
                        Text("Message \(contactVM.name)")
                        Spacer()
                    }
                }
                Link(destination: contactVM.facetimeURL!) {
                    HStack {
                        Spacer()
                        Image(systemName: "video.fill").imageScale(.large)
                        Text("Factime \(contactVM.name)")
                        Spacer()
                    }
                }
            }
            if contactVM.emailAddresses != nil {
                Link(destination: contactVM.emailURL!) {
                    HStack {
                        Spacer()
                        Image(systemName: "envelope.fill").imageScale(.large)
                        Text("Email \(contactVM.name)")
                        Spacer()
                    }
                }
            }
        } label: {
            HStack {
                Spacer()
                Image(systemName: "hand.wave.fill")
                Text("Contact \(contactVM.name)")
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
// MARK: - Previews
struct CallMessageBorrowerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CallMessageBorrowerButtonView(contactVM: ContactVM())
    }
}
