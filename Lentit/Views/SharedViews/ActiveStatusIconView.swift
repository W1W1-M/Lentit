//
//  ActiveStatusIconView.swift
//  Lentit
//
//  Created by William Mead on 06/04/2022.
//

import SwiftUI
// MARK: -
struct ActiveLoanStatusIconView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        ZStack {
            switch appVM.activeLoanStatus {
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
            default:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.black)
            }
            Image(systemName: appVM.activeLoanStatus.symbolName)
                .foregroundColor(.white)
                .font(.title2)
        }.frame(width: 30, height: 30)
    }
}
// MARK: -
struct ActiveItemStatusIconView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        ZStack {
            switch appVM.activeItemStatus {
            case .all:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.blue)
            case .available:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.green)
            case .unavailable:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.red)
            default:
                RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundColor(.black)
            }
            Image(systemName: appVM.activeItemStatus.symbolName)
                .foregroundColor(.white)
                .font(.title2)
        }.frame(width: 30, height: 30)
    }
}
// MARK: -
struct ActiveStatusIconView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveLoanStatusIconView()
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
        //
        ActiveItemStatusIconView()
            .environmentObject(AppVM())
            .previewLayout(.sizeThatFits)
    }
}
