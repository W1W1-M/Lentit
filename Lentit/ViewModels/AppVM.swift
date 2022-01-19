//
//  AppVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
/// Lentit app view model
class AppVM: ObservableObject {
    // MARK: - Variables
    @Published var dataStore: DataStoreModel
    @Published var loanVMs: Array<LoanVM>
    @Published var itemVMs: Array<ItemVM>
    @Published var borrowerVMs: Array<BorrowerVM>
    @Published var loanListVM: LoanListVM
    @Published var activeCategory: ItemCategoryModel {
        didSet{
            self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory)
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
            self.loanListVM.setLoansCount(for: loanVMs)
        }
    }
    @Published var activeSort: SortingOrder{
        didSet{
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
        }
    }
    // MARK: - Init
    init() {
        // Initialize with empty data
        self.dataStore = DataStoreModel()
        self.loanVMs = []
        self.itemVMs = []
        self.borrowerVMs = []
        self.loanListVM = LoanListVM()
        self.activeCategory = ItemCategories.all
        self.activeSort = SortingOrders.byItemName
        // Set view models
        self.itemVMs = setItemVMs(for: dataStore.readStoredItems())
        self.borrowerVMs = setBorrowerVMs(for: dataStore.readStoredBorrowers())
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
        self.loanListVM.setLoansCount(for: loanVMs)
    }
// MARK: - Functions
// MARK: - Loan
    func setLoanVMs(for loans: [LoanModel], reference itemVMs: [ItemVM], _ borrowerVMs: [BorrowerVM]) -> [LoanVM] {
        var loanVMs: [LoanVM] = []
        for loan in loans {
            let loanItemVM = getLoanItemVM(in: itemVMs, for: loan)
            let loanBorrowerVM = getLoanBorrowerVM(in: borrowerVMs, for: loan)
            let loanVM = LoanVM()
            loanVM.setLoanVM(from: loan, loanItemVM, loanBorrowerVM)
            loanVMs.append(loanVM)
        }
        return loanVMs
    }
    func createLoan() {
        let newLoan = LoanModel(
            id: UUID(),
            loanDate: Date(),
            loanTime: 100000.0, // WIP
            loanExpiry: Date(), // WIP
            reminder: Date(), // WIP
            returnedSold: false,
            justAdded: true,
            itemId: UUID(), // WIP
            borrowerId: UUID() // WIP
        )
        self.dataStore.createLoan(newLoan: newLoan)
        // Make sure all categories are shown to see new item
        self.activeCategory = ItemCategories.all
        // Reset loan view models & count
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
        self.loanListVM.setLoansCount(for: loanVMs)
    }
    func deleteLoan(for loanVM: LoanVM) {
        self.dataStore.deleteLoan(oldLoan: loanVM.loan)
        // Reload lent items count & VMs
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
    }
    func getLoanItemVM(in itemVMs: [ItemVM], for loan: LoanModel) -> ItemVM {
        var loanItemVM: ItemVM = ItemVM()
        for itemVM in itemVMs {
            if(itemVM.id == loan.itemId) {
                loanItemVM = itemVM
            }
        }
        return loanItemVM
    }
    func getLoanBorrowerVM(in borrowerVMs: [BorrowerVM], for loan: LoanModel) -> BorrowerVM {
        var loanBorrowerVM: BorrowerVM = BorrowerVM()
        for borrowerVM in borrowerVMs {
            if(borrowerVM.id == loan.borrowerId) {
                loanBorrowerVM = borrowerVM
            }
        }
        return loanBorrowerVM
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeCategory: ItemCategoryModel) -> [LoanVM] {
        var filteredLoanVMs = loanVMs
        if(activeCategory == ItemCategories.all) {
            return filteredLoanVMs
        } else {
            filteredLoanVMs = filteredLoanVMs.filter {
                $0.itemVM.category == activeCategory
            }
            return filteredLoanVMs
        }
    }
    func sortLoanVMs(for loanVMs: [LoanVM], by activeSort: SortingOrder) -> [LoanVM] {
        var sortedLoanVMs = loanVMs
        // Use switch case to sort array
        switch activeSort {
        case SortingOrders.byItemName:
            sortedLoanVMs.sort {
                $0.itemVM.nameText < $1.itemVM.nameText
            }
        case SortingOrders.byBorrowerName:
            sortedLoanVMs.sort {
                $0.borrowerVM.nameText < $1.borrowerVM.nameText
            }
        default:
            sortedLoanVMs.sort {
                $0.id < $1.id
            }
        }
        return sortedLoanVMs
    }
// MARK: - Item
    func setItemVMs(for items: [ItemModel]) -> [ItemVM] {
        var itemVMs: [ItemVM] = []
        for item in items {
            let itemVM = ItemVM()
            itemVM.setItemVM(from: item)
            itemVMs.append(itemVM)
        }
        return itemVMs
    }
// MARK: - Borrower
    func setBorrowerVMs(for borrowers: [BorrowerModel]) -> [BorrowerVM] {
        var borrowerVMs: [BorrowerVM] = []
        for borrower in borrowers {
            let borrowerVM = BorrowerVM()
            borrowerVM.setBorrowerVM(for: borrower)
            borrowerVMs.append(borrowerVM)
        }
        borrowerVMs.sort {
            $0.nameText < $1.nameText
        }
        return borrowerVMs
    }
    func createBorrower(named name: String) {
        let newBorrower = BorrowerModel(
            id: UUID(),
            name: name,
            loanIds: []
        )
        self.dataStore.createBorrower(newBorrower: newBorrower)
        self.borrowerVMs = setBorrowerVMs(for: dataStore.readStoredBorrowers())
    }
}
// MARK: - Structs
struct SortingOrders {
    static var byItemName: SortingOrder = SortingOrder(name: "byItemName")
    static var byBorrowerName: SortingOrder = SortingOrder(name: "byBorrowerName")
}

struct SortingOrder: Equatable {
    let id: UUID
    let name: String
    /// Custom initialization
    /// - Parameter name: String to describe sorting order
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
