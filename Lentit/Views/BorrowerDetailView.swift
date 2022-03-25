//
//  BorrowerDetailView.swift
//  Lentit
//
//  Created by William Mead on 25/03/2022.
//

import SwiftUI

struct BorrowerDetailView: View {
    @ObservedObject var borrowerVM: BorrowerVM
    var body: some View {
        Text("Hello, World!")
    }
}

struct BorrowerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowerDetailView(borrowerVM: BorrowerVM())
    }
}
