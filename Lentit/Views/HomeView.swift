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
                        appVM.activeElement = .Borrowers
                    } label: {
                        HStack {
                            Text("Borrowers")
                            Image(systemName: "person.circle")
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
                } label: {
                    switch appVM.activeElement {
                    case .Loans:
                        Image(systemName: "book.circle.fill")
                        Text("Loans").bold()
                        Spacer()
                    case .Borrowers:
                        Image(systemName: "person.circle.fill")
                        Text("Borrowers").bold()
                        Spacer()
                    case .Items:
                        Image(systemName: "archivebox.circle.fill")
                        Text("Items").bold()
                        Spacer()
                    }
                }.padding()
                .font(.largeTitle)
                switch appVM.activeElement {
                case .Loans:
                    LoanListStatusView(loanListVM: appVM.loanListVM)
                    if(appVM.loanListVM.loansCount == 0) {
                        Spacer()
                        CreateLoanHintView()
                        Spacer()
                    } else {
                        LoanListView(loanListVM: appVM.loanListVM)
                    }
                    NewButtonView(element: AppVM.Element.Loans)
                case .Borrowers:
                    BorrowerListView(borrowerListVM: appVM.borrowerListVM)
                    Spacer()
                    NewButtonView(element: AppVM.Element.Borrowers)
                case .Items:
                    ItemListStatusView(itemListVM: appVM.itemListVM)
                    ItemListView(itemListVM: appVM.itemListVM)
                    Spacer()
                    NewButtonView(element: AppVM.Element.Items)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
                } label: {
                    HStack {
                        Text("Settings")
                        Image(systemName: "gear")
                    }
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                switch appVM.activeElement {
                case .Loans:
                    LoanListBottomToolbarView()
                case .Borrowers:
                    EmptyView()
                case .Items:
                    ItemListBottomToolbarView()
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
