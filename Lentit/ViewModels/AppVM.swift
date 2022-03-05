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
    @Published var borrowerListVM: BorrowerListVM
    @Published var itemListVM: ItemListVM
    @Published var activeCategory: ItemCategoryModel {
        didSet{
            self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory, and: activeStatus)
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
            self.loanListVM.setLoansCount(for: loanVMs)
        }
    }
    @Published var activeSort: LoanSortingOrderModel{
        didSet{
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
        }
    }
    @Published var activeStatus: LoanStatusModel {
        didSet{
            self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory, and: activeStatus)
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
            self.loanListVM.setLoansCount(for: loanVMs)
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
        self.borrowerListVM = BorrowerListVM()
        self.itemListVM = ItemListVM()
        self.activeCategory = ItemCategories.all
        self.activeSort = LoanSortingOrders.byItemName
        self.activeStatus = LoanStatus.current
        // Set view models
        self.itemVMs = setItemVMs(for: dataStore.readStoredItems())
        self.borrowerVMs = setBorrowerVMs(for: dataStore.readStoredBorrowers())
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
        self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory, and: activeStatus)
        self.loanListVM.setLoansCount(for: loanVMs)
        self.borrowerListVM.setBorrowersCount(for: borrowerVMs)
        self.itemListVM.setItemsCount(for: itemVMs)
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
            status: LoanStatus.new,
            itemId: UUID(), // WIP
            borrowerId: UUID() // WIP
        )
        self.dataStore.createLoan(newLoan: newLoan)
        self.activeCategory = ItemCategories.all
        self.activeStatus = LoanStatus.new
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
    func filterLoanVMs(for loanVMs: [LoanVM], by activeCategory: ItemCategoryModel, and activeStatus: LoanStatusModel) -> [LoanVM] {
        var filteredLoanVMs = loanVMs
        if(activeCategory == ItemCategories.all) {
            filteredLoanVMs = filteredLoanVMs.filter {
                $0.status == activeStatus
            }
            return filteredLoanVMs
        } else {
            filteredLoanVMs = filteredLoanVMs.filter {
                $0.itemVM.category == activeCategory && $0.status == activeStatus
            }
            return filteredLoanVMs
        }
    }
    func sortLoanVMs(for loanVMs: [LoanVM], by activeSort: LoanSortingOrderModel) -> [LoanVM] {
        var sortedLoanVMs = loanVMs
        // Use switch case to sort array
        switch activeSort {
        case LoanSortingOrders.byItemName:
            sortedLoanVMs.sort {
                $0.itemVM.nameText < $1.itemVM.nameText
            }
        case LoanSortingOrders.byBorrowerName:
            sortedLoanVMs.sort {
                $0.borrowerVM.nameText < $1.borrowerVM.nameText
            }
        case LoanSortingOrders.byLoanDate:
            sortedLoanVMs.sort {
                $0.loanDate < $1.loanDate
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
    func createItem(id: UUID, named name: String, worth value: Int, typed category: ItemCategoryModel) {
        let newItem = ItemModel(
            id: id,
            name: name,
            description: "",
            value: value,
            category: category,
            status: ItemStatus.new,
            loanIds: []
        )
        self.dataStore.createItem(newItem: newItem)
        self.itemVMs = setItemVMs(for: dataStore.readStoredItems())
    }
    func getItem(id: UUID) -> ItemVM {
        if let itemVM = itemVMs.first(where: { $0.id == id }) {
            return itemVM
        } else {
            return ItemVM()
        }
    }
    func filterItemVMs(for itemVMs: [ItemVM], by activeCategory: ItemCategoryModel) -> [ItemVM] {
        var filteredItemVMs = itemVMs
        if(activeCategory == ItemCategories.all) {
            return filteredItemVMs
        } else {
            filteredItemVMs = filteredItemVMs.filter {
                $0.category == activeCategory
            }
            return filteredItemVMs
        }
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
            justAdded: true,
            loanIds: []
        )
        self.dataStore.createBorrower(newBorrower: newBorrower)
        self.borrowerVMs = setBorrowerVMs(for: dataStore.readStoredBorrowers())
    }
    func getBorrowerJustAdded() -> BorrowerVM {
        var justAddedBorrowerVM = BorrowerVM()
        for borrowerVM in self.borrowerVMs {
            if(borrowerVM.borrowerJustAdded) {
                justAddedBorrowerVM = borrowerVM
                borrowerVM.borrowerJustAdded = false
            }
        }
        return justAddedBorrowerVM
    }
}
