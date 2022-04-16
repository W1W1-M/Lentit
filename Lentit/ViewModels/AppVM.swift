//
//  AppVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
import EventKit
import Contacts
/// Lentit app view model
final class AppVM: ViewModel, ObservableObject {
// MARK: - Properties
    internal var id: UUID
    @Published var dataStore: DataStoreModel {
        didSet {
            switch activeElement {
            case .Loans:
                self.loanListEntryVMs = setLoanListEntryVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
            case .Items:
                self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
            case .Borrowers:
                self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
            }
        }
    }
    // List entry view models
    @Published var loanListEntryVMs: Array<LoanListEntryVM> {
        didSet {
            loanListVM.setLoansCount(for: loanListEntryVMs)
        }
    }
    @Published var itemListEntryVMs: Array<ItemListEntryVM> {
        didSet {
            itemListVM.setItemsCount(for: itemListEntryVMs)
        }
    }
    @Published var borrowerListEntryVMs: Array<BorrowerListEntryVM> {
        didSet {
            borrowerListVM.setBorrowersCount(for: borrowerListEntryVMs)
        }
    }
    // List view models
    @Published var loanListVM: LoanListVM
    @Published var itemListVM: ItemListVM
    @Published var borrowerListVM: BorrowerListVM
    // Active views models
    @Published var activeItemCategory: ItemModel.Category {
        didSet {
            switch activeElement {
            case .Loans:
                self.loanListEntryVMs = setLoanListEntryVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
                self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeItemCategory)
                self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanStatus)
                self.loanListEntryVMs = sortLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanSort)
            case .Items:
                self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
                self.itemListEntryVMs = filterItemListEntryVMs(for: itemListEntryVMs, by: activeItemCategory)
                self.itemListEntryVMs = sortItemListEntryVMs(for: itemListEntryVMs, by: activeItemSort)
            case .Borrowers:
                self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
            }
        }
    }
    @Published var activeItemSort: ItemModel.SortingOrder {
        didSet {
            self.itemListEntryVMs = sortItemListEntryVMs(for: itemListEntryVMs, by: activeItemSort)
        }
    }
    @Published var activeItemStatus: StatusModel {
        didSet {
            self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
            self.itemListEntryVMs = filterItemListEntryVMs(for: itemListEntryVMs, by: activeItemStatus)
            self.itemListEntryVMs = sortItemListEntryVMs(for: itemListEntryVMs, by: activeItemSort)
        }
    }
    @Published var activeLoanSort: LoanModel.SortingOrder {
        didSet {
            self.loanListEntryVMs = sortLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanSort)
        }
    }
    @Published var activeLoanStatus: StatusModel {
        didSet {
            self.loanListEntryVMs = setLoanListEntryVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
            self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanStatus)
            self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeItemCategory)
            self.loanListEntryVMs = sortLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanSort)
        }
    }
    @Published var activeBorrowerStatus: StatusModel {
        didSet {
            
        }
    }
    @Published var activeBorrower: BorrowerVM {
        didSet {
            
        }
    }
    @Published var activeItem: ItemVM {
        didSet {
            
        }
    }
    @Published var activeElement: Element {
        didSet {
            switch activeElement {
            case .Loans:
                self.activeLoanStatus = .all
                self.activeItemCategory = .all
                self.loanListEntryVMs = setLoanListEntryVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
                self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanStatus)
                self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeItemCategory)
                self.loanListEntryVMs = sortLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanSort)
            case .Items:
                self.activeItemStatus = .all
                self.activeItemCategory = .all
                self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
                self.itemListEntryVMs = filterItemListEntryVMs(for: itemListEntryVMs, by: activeItemStatus)
                self.itemListEntryVMs = sortItemListEntryVMs(for: itemListEntryVMs, by: activeItemSort)
            case .Borrowers:
                self.activeBorrowerStatus = .all
                self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
            }
        }
    }
    @Published var alertPresented: Bool
    @Published var sheetPresented: Bool
    @Published var activeAlert: AlertModel
    @Published var activeSheet: SheetModel
    enum Element {
        case Loans
        case Items
        case Borrowers
    }
    // EventKit
    internal var eventStore: EKEventStore
    internal var remindersAccess: EKAuthorizationStatus
    internal var remindersDefaultCalendar: EKCalendar?
    //
    internal let contactsStore: CNContactStore
    internal var contactsAccess: CNAuthorizationStatus
// MARK: - Init & deinit
    init() {
        print("AppVM init ...")
        // Initialize properties
        self.id = UUID()
        self.dataStore = DataStoreModel()
        self.loanListEntryVMs = []
        self.itemListEntryVMs = []
        self.borrowerListEntryVMs = []
        self.loanListVM = LoanListVM()
        self.borrowerListVM = BorrowerListVM()
        self.itemListVM = ItemListVM()
        self.activeItemCategory = .all
        self.activeItemStatus = .all
        self.activeItemSort = .byName
        self.activeLoanSort = .byItemName
        self.activeLoanStatus = .current
        self.activeBorrowerStatus = .regular
        self.activeBorrower = BorrowerVM()
        self.activeItem = ItemVM()
        self.activeElement = .Loans
        self.alertPresented = false
        self.sheetPresented = false
        self.activeAlert = .deleteLoan
        self.activeSheet = .itemsList
        self.eventStore = EKEventStore()
        self.remindersAccess = .notDetermined
        self.remindersDefaultCalendar = nil
        self.contactsStore = CNContactStore()
        self.contactsAccess = .notDetermined
        // Set properties
        self.loanListEntryVMs = setLoanListEntryVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
        self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanStatus)
        self.loanListEntryVMs = filterLoanListEntryVMs(for: loanListEntryVMs, by: activeItemCategory)
        self.loanListEntryVMs = sortLoanListEntryVMs(for: loanListEntryVMs, by: activeLoanSort)
    }
    deinit {
        print("... deinit AppVM")
    }
// MARK: - Methods
    func setVM() {
        
    }
// MARK: - Loan
    func setLoanListEntryVMs(for loans: [LoanModel], _ items: [ItemModel], _ borrowers: [BorrowerModel]) -> [LoanListEntryVM] {
        print("setLoanListEntryVMs ...")
        var loanListEntryVMs: [LoanListEntryVM] = []
        for loan in loans {
            let loanItem = getLoanItem(in: items, for: loan)
            let loanBorrower = getLoanBorrower(in: borrowers, for: loan)
            let loanListEntryVM = LoanListEntryVM()
            loanListEntryVM.setVM(from: loan, loanItem, loanBorrower)
            loanListEntryVMs.append(loanListEntryVM)
        }
        print("... setLoanListEntryVMs")
        return loanListEntryVMs
    }
    func createEmptyLoan() {
        print("createEmptyLoan ...")
        let newLoan = LoanModel(
            loanDate: Date(),
            loanTime: 100000.0, // WIP
            ekReminderId: nil,
            reminderDate: nil,
            reminderActive: false,
            returned: false,
            status: StatusModel.new,
            itemId: nil,
            borrowerId: nil
        )
        self.dataStore.createLoan(newLoan: newLoan)
        self.activeItemCategory = ItemModel.Category.all
        self.activeLoanStatus = StatusModel.new
        print("... createEmptyLoan \(newLoan.id)")
    }
    func deleteLoan(for loanVM: LoanVM) {
        print("deleteLoan \(loanVM.id) ...")
        self.dataStore.deleteLoan(oldLoan: loanVM.loan)
        self.loanListEntryVMs = setLoanListEntryVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
    }
    func getLoanVM(for id: UUID) -> LoanVM {
        print("getLoanVM ...")
        do {
            var loanItem: ItemModel
            var loanBorrower: BorrowerModel
            var loan: LoanModel
            loan = try dataStore.readStoredLoan(id)
            if let loanItemId = loan.itemId {
                loanItem = try dataStore.readStoredItem(loanItemId)
            } else {
                loanItem = ItemModel.defaultData
            }
            if let loanBorrowerId = loan.borrowerId {
                loanBorrower = try dataStore.readStoredBorrower(loanBorrowerId)
            } else {
                loanBorrower = BorrowerModel.defaultData
            }
            let loanVM = LoanVM()
            loanVM.setLoanVM(from: loan, loanItem, loanBorrower)
            print("... getLoanVM \(id)")
            return loanVM
        } catch {
            print(error)
            return LoanVM()
        }
    }
    func getLoanListEntryVM(with id: UUID, in loanListEntryVMs: [LoanListEntryVM]) -> LoanListEntryVM {
        if let loanListEntryVM = loanListEntryVMs.first(where: { $0.id == id }) {
            return loanListEntryVM
        } else {
            return LoanListEntryVM()
        }
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
    func getLoanItem(in items: [ItemModel], for loan: LoanModel) -> ItemModel {
        var loanItem: ItemModel = ItemModel.defaultData
        for item in items {
            if(item.id == loan.itemId) {
                loanItem = item
            }
        }
        return loanItem
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
    func getLoanBorrower(in borrowers: [BorrowerModel], for loan: LoanModel) -> BorrowerModel {
        var loanBorrower: BorrowerModel = BorrowerModel.defaultData
        for borrower in borrowers {
            if(borrower.id == loan.borrowerId) {
                loanBorrower = borrower
            }
        }
        return loanBorrower
    }
    func filterLoanListEntryVMs(for loanListEntryVMs: [LoanListEntryVM], by activeCategory: ItemModel.Category) -> [LoanListEntryVM] {
        if(activeCategory == ItemModel.Category.all) {
            return loanListEntryVMs
        } else {
            return loanListEntryVMs.filter { $0.itemCategory == activeCategory }
        }
    }
    func filterLoanListEntryVMs(for loanListEntryVMs: [LoanListEntryVM], by activeStatus: StatusModel) -> [LoanListEntryVM] {
        if(activeStatus == .all) {
            return loanListEntryVMs
        } else {
            return loanListEntryVMs.filter { $0.loanStatus == activeStatus }
        }
    }
    func filterLoanListEntryVMs(for loanListEntryVMs: [LoanListEntryVM], by activeBorrower: BorrowerVM) -> [LoanListEntryVM] {
        loanListEntryVMs.filter { $0.borrowerName == activeBorrower.name } // WIP
    }
    func filterLoanListEntryVMs(for loanListEntryVMs: [LoanListEntryVM], by activeItem: ItemVM) -> [LoanListEntryVM] {
        loanListEntryVMs.filter { $0.itemName == activeItem.nameText } // WIP
    }
    func sortLoanListEntryVMs(for loanListEntryVMs: [LoanListEntryVM], by activeSort: LoanModel.SortingOrder) -> [LoanListEntryVM] {
        var sortedLoanListEntryVMs = loanListEntryVMs
        // Use switch case to sort array
        switch activeSort {
        case LoanModel.SortingOrder.byItemName:
            sortedLoanListEntryVMs.sort {
                $0.itemName < $1.itemName
            }
        case LoanModel.SortingOrder.byBorrowerName:
            sortedLoanListEntryVMs.sort {
                $0.borrowerName < $1.borrowerName
            }
        case LoanModel.SortingOrder.byLoanDate:
            sortedLoanListEntryVMs.sort {
                $0.loanDate < $1.loanDate
            }
        default:
            sortedLoanListEntryVMs.sort {
                $0.id < $1.id
            }
        }
        return sortedLoanListEntryVMs
    }
// MARK: - Item
    func setItemListEntryVMs(for items: [ItemModel]) -> [ItemListEntryVM] {
        var itemListEntryVMs: Array<ItemListEntryVM> = []
        for item in items {
            let itemListEntryVM = ItemListEntryVM()
            itemListEntryVM.setVM(from: item)
            itemListEntryVMs.append(itemListEntryVM)
        }
        return itemListEntryVMs
    }
    func createItem(named name: String, typed category: ItemModel.Category) -> UUID {
        let newItem = ItemModel(
            name: name,
            notes: "",
            value: 0,
            category: category,
            status: StatusModel.new,
            loanIds: []
        )
        self.dataStore.createItem(newItem: newItem)
        self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
        return newItem.id
    }
    func createEmptyItem() {
        let newItem = ItemModel(
            name: "",
            notes: "",
            value: 0,
            category: ItemModel.Category.other,
            status: StatusModel.new,
            loanIds: []
        )
        self.dataStore.createItem(newItem: newItem)
        self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
    }
    func getItemVM(for id: UUID) -> ItemVM {
        print("getItemVM ...")
        do {
            var item: ItemModel
            item = try dataStore.readStoredItem(id)
            let itemVM = ItemVM()
            itemVM.setVM(from: item)
            print("... getItemVM \(id)")
            return itemVM
        } catch {
            print(error)
            return ItemVM()
        }
    }
    func getListEntryItemVM(with id: UUID) -> ItemListEntryVM {
        if let itemListEntryVM = itemListEntryVMs.first(where: { $0.id == id }) {
            return itemListEntryVM
        } else {
            return ItemListEntryVM()
        }
    }
    func deleteItem(for itemVM: ItemVM) {
        self.dataStore.deleteItem(oldItem: itemVM.item)
        self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
    }
    func filterItemListEntryVMs(for itemListEntryVMs: [ItemListEntryVM], by activeCategory: ItemModel.Category) -> [ItemListEntryVM] {
        var filteredItemListEntryVMs = itemListEntryVMs
        if(activeCategory == ItemModel.Category.all) {
            return filteredItemListEntryVMs
        } else {
            filteredItemListEntryVMs = filteredItemListEntryVMs.filter {
                $0.category == activeCategory
            }
            return filteredItemListEntryVMs
        }
    }
    func filterItemListEntryVMs(for itemListEntryVMs: [ItemListEntryVM], by activeStatus: StatusModel) -> [ItemListEntryVM] {
        var filteredItemListEntryVMs = itemListEntryVMs
        if(activeStatus == StatusModel.all) {
            return filteredItemListEntryVMs
        } else {
            filteredItemListEntryVMs = filteredItemListEntryVMs.filter {
                $0.status == activeStatus
            }
            return filteredItemListEntryVMs
        }
    }
    func sortItemListEntryVMs(for itemListEntryVMs: [ItemListEntryVM], by activeSort: ItemModel.SortingOrder) -> [ItemListEntryVM] {
        var sortedItemListEntryVMs = itemListEntryVMs
        // Use switch case to sort array
        switch activeSort {
        case ItemModel.SortingOrder.byName:
            sortedItemListEntryVMs.sort {
                $0.name < $1.name
            }
        default:
            sortedItemListEntryVMs.sort {
                $0.name < $1.name
            }
        }
        return sortedItemListEntryVMs
    }
// MARK: - Borrower
    func setBorrowerListEntryVMs(for borrowers: [BorrowerModel]) -> [BorrowerListEntryVM] {
        var borrowerListEntryVMs: Array<BorrowerListEntryVM> = []
        for borrower in borrowers {
            let borrowerListEntryVM = BorrowerListEntryVM()
            borrowerListEntryVM.setVM(from: borrower)
            borrowerListEntryVMs.append(borrowerListEntryVM)
        }
        return borrowerListEntryVMs
    }
    func createBorrower(named name: String) -> UUID {
        let newBorrower = BorrowerModel(
            name: name,
            status: StatusModel.new,
            loanIds: []
        )
        self.dataStore.createBorrower(newBorrower: newBorrower)
        self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
        return newBorrower.id
    }
    func createEmptyBorrower() {
        let newBorrower = BorrowerModel(
            name: "",
            status: StatusModel.new,
            loanIds: []
        )
        self.dataStore.createBorrower(newBorrower: newBorrower)
        self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
    }
    func getBorrowerDetailVM(for id: UUID) -> BorrowerDetailVM {
        print("getBorrowerDetailVM ...")
        do {
            var borrower: BorrowerModel
            borrower = try dataStore.readStoredBorrower(id)
            let borrowerDetailVM = BorrowerDetailVM()
            borrowerDetailVM.setVM(from: borrower)
            print("... getBorrowerDetailVM \(id)")
            return borrowerDetailVM
        } catch {
            print(error)
            return BorrowerDetailVM()
        }
    }
    func getBorrowerListEntryVM(with id: UUID) -> BorrowerListEntryVM {
        if let borrowerListEntryVM = borrowerListEntryVMs.first(where: { $0.id == id }) {
            return borrowerListEntryVM
        } else {
            return BorrowerListEntryVM()
        }
    }
    func deleteBorrower(for id: UUID) {
        self.dataStore.deleteBorrower(oldBorrowerId: id)
        self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
    }
// MARK: - Reminder
    func getReminderVM(for loan: LoanModel) -> ReminderVM {
        let loanItem = getLoanItem(in: dataStore.readStoredItems(), for: loan)
        let loanBorrower = getLoanBorrower(in: dataStore.readStoredBorrowers(), for: loan)
        let reminderTitle: String = "Loan to \(loanBorrower.name)"
        let reminderNotes: String = "\(loanItem.name)"
        let reminderVM = ReminderVM(
            loan: loan,
            reminderTitle: reminderTitle,
            reminderNotes: reminderNotes,
            eventStore: eventStore,
            reminderAccess: remindersAccess,
            reminderDefaultCalendar: remindersDefaultCalendar
        )
        return reminderVM
    }
}
