//
//  ActiveStatusIconView.swift
//  Lentit
//
//  Created by William Mead on 06/04/2022.
//

import SwiftUI
// MARK: - Views
struct ActiveStatusIconView: View {
    internal var activeStatus: StatusModel
    var body: some View {
        ZStack {
            switch activeStatus {
            case .all:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.blue)
            case .new:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.purple)
            case .upcoming:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.orange)
            case .current:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.green)
            case .finished:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.red)
            case .available:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.green)
            case .unavailable:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.red)
            default:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.black)
            }
            Image(systemName: activeStatus.symbolName)
                .foregroundColor(.white)
                .font(.title2)
        }.frame(width: 30, height: 30)
    }
}
// MARK: - Previews
struct ActiveStatusIconView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveStatusIconView(activeStatus: .current).previewLayout(.sizeThatFits)
    }
}
