//
//  TipView.swift
//  Lentit
//
//  Created by William Mead on 14/03/2022.
//

import SwiftUI
// MARK: - Views
struct TipView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        VStack {
            Text("No \(appVM.activeStatus.name) Loans (\(appVM.activeCategory.name))")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding()
            Image(systemName: "eyes")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding()
            Text("Tip: Select or Create a loan")
                .font(.headline)
                .italic()
                .foregroundColor(.secondary)
                .padding()
        }
    }
}
// MARK: - Previews
struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        TipView()
    }
}
