//
//  HintView.swift
//  Lentit
//
//  Created by William Mead on 14/03/2022.
//

import SwiftUI
// MARK: - Views
struct HintView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        CreateLoanHintView()
    }
}
// MARK: - Views
struct CreateLoanHintView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        VStack {
            VStack {
                Text("No Loans").font(.title)
                ItemCategoryFullNameView(itemCategory: appVM.activeCategory).padding(2)
            }.padding()
            Image(systemName: "\(Tips.createLoan.hintSymbol1)")
                .font(.largeTitle)
                .imageScale(.large)
                .padding()
            Text("Hint: Create a loan")
                .font(.headline)
                .italic()
                .padding()
            Image(systemName: "\(Tips.createLoan.hintSymbol2)")
                .font(.largeTitle)
                .imageScale(.large)
                .padding()
        }.foregroundColor(.secondary)
    }
}
// MARK: - Views
struct SelectLoanHintView: View {
    var body: some View {
        VStack {
            VStack {
                Text("No Loan Selected").font(.title)
            }.padding()
            Image(systemName: "\(Tips.selectLoan.hintSymbol1)")
                .font(.largeTitle)
                .imageScale(.large)
                .padding()
            Text("Hint: Select a loan from the list")
                .font(.headline)
                .italic()
                .padding()
            Image(systemName: "\(Tips.selectLoan.hintSymbol2)")
                .font(.largeTitle)
                .imageScale(.large)
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
        SelectLoanHintView().previewLayout(.sizeThatFits)
    }
}
