//
//  CircleImageView.swift
//  Lentit
//
//  Created by William Mead on 28/03/2022.
//

import SwiftUI
// MARK: - Views
struct CircleImageView: View {
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.accentColor)
                Text("Image")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            Spacer()
        }.listRowBackground(Color("BackgroundColor"))
    }
}
// MARK: - Previews
struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView().previewLayout(.sizeThatFits)
    }
}
