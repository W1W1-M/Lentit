//
//  HintView.swift
//  Lentit
//
//  Created by William Mead on 14/03/2022.
//

import SwiftUI
// MARK: - Views
struct CreateLoanHintView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        VStack {
            VStack {
                Text("No Loans").font(.title)
                ItemCategoryFullNameView(itemCategoryModel: appVM.activeCategory).padding(2)
            }.padding()
            Image(systemName: "\(Tips.createLoan.hintSymbol1)")
                .font(.system(size: 60))
                .padding()
            Text("Hint: Create a loan")
                .font(.headline)
                .italic()
                .padding()
            Image(systemName: "\(Tips.createLoan.hintSymbol2)")
                .font(.system(size: 40))
                .padding()
        }.foregroundColor(.secondary)
    }
}
// MARK: - Previews
struct HintView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLoanHintView()
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
    }
}
