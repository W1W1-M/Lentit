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
    @Published var loanVMs: Array<LoanVM> {
        didSet{
            loanListVM.setLoansCount(for: loanVMs)
        }
    }
    @Published var itemVMs: Array<ItemVM> {
        didSet{
            itemListVM.setItemsCount(for: itemVMs)
        }
    }
    @Published var borrowerVMs: Array<BorrowerVM> {
        didSet{
            borrowerListVM.setBorrowersCount(for: borrowerVMs)
        }
    }
    @Published var loanListVM: LoanListVM
    @Published var borrowerListVM: BorrowerListVM
    @Published var itemListVM: ItemListVM
    @Published var activeCategory: ItemModel.Category {
        didSet{
            self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeStatus)
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
            self.loanListVM.setLoansCount(for: loanVMs)
        }
    }
    @Published var activeSort: LoanModel.SortingOrder {
        didSet{
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
        }
    }
    @Published var activeStatus: LoanModel.Status {
        didSet{
            self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeStatus)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory)
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeSort)
            self.loanListVM.setLoansCount(for: loanVMs)
        }
    }
    @Published var activeBorrower: BorrowerVM {
        didSet{
            
        }
    }
    @Published var activeItem: ItemVM {
        didSet{
            
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
        self.activeCategory = ItemModel.Category.all
        self.activeSort = LoanModel.SortingOrder.byItemName
        self.activeStatus = LoanModel.Status.current
        self.activeBorrower = BorrowerVM()
        self.activeItem = ItemVM()
        // Set view models
        self.itemVMs = setItemVMs(for: dataStore.readStoredItems())
        self.borrowerVMs = setBorrowerVMs(for: dataStore.readStoredBorrowers())
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), reference: itemVMs, borrowerVMs)
        self.loanVMs = filterLoanVMs(for: loanVMs, by: activeStatus)
        self.loanVMs = filterLoanVMs(for: loanVMs, by: activeCategory)
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
            loanDate: Date(),
            loanTime: 100000.0, // WIP
            reminder: Date(timeIntervalSinceNow: 30*24*60*60), // WIP
            reminderActive: false,
            returned: false,
            status: LoanModel.Status.new,
            itemId: UUID(), // WIP
            borrowerId: UUID() // WIP
        )
        self.dataStore.createLoan(newLoan: newLoan)
        self.activeCategory = ItemModel.Category.all
        self.activeStatus = LoanModel.Status.new
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
    func filterLoanVMs(for loanVMs: [LoanVM], by activeCategory: ItemModel.Category) -> [LoanVM] {
        if(activeCategory == ItemModel.Category.all) {
            return loanVMs
        } else {
            return loanVMs.filter { $0.itemVM.category == activeCategory }
        }
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeStatus: LoanModel.Status) -> [LoanVM] {
        loanVMs.filter { $0.status == activeStatus }
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeBorrower: BorrowerVM) -> [LoanVM] {
        loanVMs.filter { $0.borrowerVM == activeBorrower }
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeItem: ItemVM) -> [LoanVM] {
        loanVMs.filter { $0.itemVM == activeItem }
    }
    func sortLoanVMs(for loanVMs: [LoanVM], by activeSort: LoanModel.SortingOrder) -> [LoanVM] {
        var sortedLoanVMs = loanVMs
        // Use switch case to sort array
        switch activeSort {
        case LoanModel.SortingOrder.byItemName:
            sortedLoanVMs.sort {
                $0.itemVM.nameText < $1.itemVM.nameText
            }
        case LoanModel.SortingOrder.byBorrowerName:
            sortedLoanVMs.sort {
                $0.borrowerVM.nameText < $1.borrowerVM.nameText
            }
        case LoanModel.SortingOrder.byLoanDate:
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
    func createItem(named name: String, worth value: Int, typed category: ItemModel.Category) -> UUID {
        let newItem = ItemModel(
            name: name,
            description: "",
            value: value,
            category: category,
            status: ItemModel.Status.new,
            loanIds: []
        )
        self.dataStore.createItem(newItem: newItem)
        self.itemVMs = setItemVMs(for: dataStore.readStoredItems())
        return newItem.id
    }
    func getItem(with id: UUID) -> ItemVM {
        if let itemVM = itemVMs.first(where: { $0.id == id }) {
            return itemVM
        } else {
            return ItemVM()
        }
    }
    func filterItemVMs(for itemVMs: [ItemVM], by activeCategory: ItemModel.Category) -> [ItemVM] {
        var filteredItemVMs = itemVMs
        if(activeCategory == ItemModel.Category.all) {
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
    func createBorrower(named name: String) -> UUID {
        let newBorrower = BorrowerModel(
            name: name,
            status: BorrowerModel.Status.new,
            loanIds: []
        )
        self.dataStore.createBorrower(newBorrower: newBorrower)
        self.borrowerVMs = setBorrowerVMs(for: dataStore.readStoredBorrowers())
        return newBorrower.id
    }
    func getBorrower(with id: UUID) -> BorrowerVM {
        if let borrowerVM = borrowerVMs.first(where: { $0.id == id }) {
            return borrowerVM
        } else {
            return BorrowerVM()
        }
    }
}
