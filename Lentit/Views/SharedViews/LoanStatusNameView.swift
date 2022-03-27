//
//  LoanStatusNameView.swift
//  Lentit
//
//  Created by William Mead on 27/03/2022.
//

import SwiftUI

struct LoanStatusNameView: View {
    let loanStatus: LoanModel.Status
    var body: some View {
        switch loanStatus {
        case .new:
            Text("new")
        case .upcoming:
            Text("upcoming")
        case .current:
            Text("ongoing")
        case .finished:
            Text("finished")
        default:
            Text("unknown")
        }
    }
}

struct LoanStatusNameView_Previews: PreviewProvider {
    static var previews: some View {
        LoanStatusNameView(loanStatus: LoanModel.Status.current).previewLayout(.sizeThatFits)
    }
}
