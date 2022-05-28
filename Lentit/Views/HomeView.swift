//
//  HomeView.swift
//  Lentit
//
//  Created by William Mead on 19/12/2021.
//

import SwiftUI
// MARK: - Views
struct HomeView: View {
    @EnvironmentObject var appVM: AppVM
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                Menu {
                    Button {
                        appVM.activeElement = .Loans
                    } label: {
                        HStack {
                            Text("Loans")
                            Image(systemName: "book.circle")
                        }
                    }
                    Button {
                        appVM.activeElement = .Items
                    } label: {
                        HStack {
                            Text("Items")
                            Image(systemName: "archivebox.circle")
                        }
                    }
                    Button {
                        appVM.activeElement = .Borrowers
                    } label: {
                        HStack {
                            Text("Borrowers")
                            Image(systemName: "person.circle")
                        }
                    }
                } label: {
                    switch appVM.activeElement {
                    case .Loans:
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                            Image(systemName: "book.circle")
                                .foregroundColor(.white)
                                .font(.title2)
                        }.frame(width: 30, height: 30)
                        Text("Loans").bold()
                        Spacer()
                    case .Items:
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                            Image(systemName: "archivebox.circle")
                                .foregroundColor(.white)
                                .font(.title2)
                        }.frame(width: 30, height: 30)
                        Text("Items").bold()
                        Spacer()
                    case .Borrowers:
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                            Image(systemName: "person.circle")
                                .foregroundColor(.white)
                                .font(.title2)
                        }.frame(width: 30, height: 30)
                        Text("Borrowers").bold()
                        Spacer()
                    }
                }.padding(.horizontal)
                .font(.largeTitle)
                switch appVM.activeElement {
                case .Loans:
                    LoanListView(loanListVM: appVM.loanListVM)
                    if(appVM.loanListVM.loansCount == 0) {
                        CreateLoanHintView()
                    }
                    NewButtonView(element: AppVM.Element.Loans)
                case .Items:
                    ItemListView(itemListVM: appVM.itemListVM)
                    Spacer()
                    NewButtonView(element: AppVM.Element.Items)
                case .Borrowers:
                    BorrowerListView(borrowerListVM: appVM.borrowerListVM)
                    Spacer()
                    NewButtonView(element: AppVM.Element.Borrowers)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    appVM.dataStore.addSampleData()
                } label: {
                    HStack {
                        Text("Sample Data")
                        Image(systemName: "gear")
                    }
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                switch appVM.activeElement {
                case .Loans:
                    LoanListBottomToolbarView()
                case .Items:
                    ItemListBottomToolbarView()
                case .Borrowers:
                    BorrowerListBottomToolbarView()
                }
            }
        }
        .onAppear(perform: {
            // Background color fix
            UITableView.appearance().backgroundColor = .clear
        })
    }
}
// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        //
        NavigationView {
            HomeView()
        }.environmentObject(AppVM())
    }
}
