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
    @Published var dataStore: DataStoreModel {
        didSet {
            switch activeElement {
            case .Loans:
                self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
            case .Items:
                self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
            case .Borrowers:
                self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
            }
        }
    }
    // List entry view models
    @Published var loanVMs: Array<LoanVM> {
        didSet {
            loanListVM.setLoansCount(for: loanVMs)
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
                self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
                self.loanVMs = filterLoanVMs(for: loanVMs, by: activeItemCategory)
                self.loanVMs = filterLoanVMs(for: loanVMs, by: activeLoanStatus)
                self.loanVMs = sortLoanVMs(for: loanVMs, by: activeLoanSort)
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
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeLoanSort)
        }
    }
    @Published var activeLoanStatus: StatusModel {
        didSet {
            self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeLoanStatus)
            self.loanVMs = filterLoanVMs(for: loanVMs, by: activeItemCategory)
            self.loanVMs = sortLoanVMs(for: loanVMs, by: activeLoanSort)
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
                self.activeLoanStatus = .current
                self.activeItemCategory = .all
                self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
                self.loanVMs = filterLoanVMs(for: loanVMs, by: activeLoanStatus)
                self.loanVMs = filterLoanVMs(for: loanVMs, by: activeItemCategory)
                self.loanVMs = sortLoanVMs(for: loanVMs, by: activeLoanSort)
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
    // Contacts
    internal var contactsStore: CNContactStore
    internal var contactsAccess: CNAuthorizationStatus
// MARK: - Init & deinit
    override init() {
        print("AppVM init ...")
        // Initialize properties
        self.dataStore = DataStoreModel()
        self.loanVMs = []
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
        super.init()
        // Set properties
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
        self.loanVMs = filterLoanVMs(for: loanVMs, by: activeLoanStatus)
        self.loanVMs = filterLoanVMs(for: loanVMs, by: activeItemCategory)
        self.loanVMs = sortLoanVMs(for: loanVMs, by: activeLoanSort)
        self.itemListEntryVMs = setItemListEntryVMs(for: dataStore.readStoredItems())
        self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
    }
    deinit {
        print("... deinit AppVM")
    }
// MARK: - Methods
    func setVM() {
        
    }
// MARK: - Loan
    func setLoanVMs(for loans: [LoanModel], _ items: [ItemModel], _ borrowers: [BorrowerModel]) -> [LoanVM] {
        print("setLoanVMs ...")
        var loanVMs: [LoanVM] = []
        for loan in loans {
            let loanItem = getLoanItem(in: items, for: loan)
            let loanBorrower = getLoanBorrower(in: borrowers, for: loan)
            let loanVM = LoanVM()
            loanVM.setVM(from: loan, loanItem, loanBorrower)
            loanVMs.append(loanVM)
        }
        print("... setLoanVMs")
        return loanVMs
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
        self.loanVMs = setLoanVMs(for: dataStore.readStoredLoans(), dataStore.readStoredItems(), dataStore.readStoredBorrowers())
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
            loanVM.setVM(from: loan, loanItem, loanBorrower)
            print("... getLoanVM \(id)")
            return loanVM
        } catch {
            print(error)
            return LoanVM()
        }
    }
    func getLoanVM(with id: UUID, in loanVMs: [LoanVM]) -> LoanVM {
        if let loanVM = loanVMs.first(where: { $0.id == id }) {
            return loanVM
        } else {
            return LoanVM()
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
    func filterLoanVMs(for loanVMs: [LoanVM], by activeCategory: ItemModel.Category) -> [LoanVM] {
        if(activeCategory == ItemModel.Category.all) {
            return loanVMs
        } else {
            return loanVMs.filter { $0.loanItemCategory == activeCategory }
        }
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeStatus: StatusModel) -> [LoanVM] {
        if(activeStatus == .all) {
            return loanVMs
        } else {
            return loanVMs.filter { $0.status == activeStatus }
        }
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeBorrower: BorrowerVM) -> [LoanVM] {
        loanVMs.filter { $0.loanBorrowerName == activeBorrower.name } // WIP
    }
    func filterLoanVMs(for loanVMs: [LoanVM], by activeItem: ItemVM) -> [LoanVM] {
        loanVMs.filter { $0.loanItemName == activeItem.nameText } // WIP
    }
    func sortLoanVMs(for loanVMs: [LoanVM], by activeSort: LoanModel.SortingOrder) -> [LoanVM] {
        var sortedLoanVMs = loanVMs
        // Use switch case to sort array
        switch activeSort {
        case LoanModel.SortingOrder.byItemName:
            sortedLoanVMs.sort {
                $0.loanItemName < $1.loanItemName
            }
        case LoanModel.SortingOrder.byBorrowerName:
            sortedLoanVMs.sort {
                $0.loanBorrowerName < $1.loanBorrowerName
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
            contactLink: false,
            contactId: nil,
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
            contactLink: false,
            contactId: nil,
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
    func getBorrower(with ud: UUID) -> BorrowerModel {
        print("getBorrower ...")
        var borrower = BorrowerModel.defaultData
        do {
            borrower = try dataStore.readStoredBorrower(id)
            return borrower
        } catch {
            print("borrower \(id) not found, defaulting to unknown borrower")
            return borrower
        }
    }
    func deleteBorrower(for id: UUID) {
        self.dataStore.deleteBorrower(oldBorrowerId: id)
        self.borrowerListEntryVMs = setBorrowerListEntryVMs(for: dataStore.readStoredBorrowers())
    }
// MARK: - Reminders
    func getRemindersVM(for loan: LoanModel) -> RemindersVM {
        let loanItem = getLoanItem(in: dataStore.readStoredItems(), for: loan)
        let loanBorrower = getLoanBorrower(in: dataStore.readStoredBorrowers(), for: loan)
        let reminderTitle: String = "Loan to \(loanBorrower.name)"
        let reminderNotes: String = "\(loanItem.name)"
        let remindersVM = RemindersVM(
            loan: loan,
            reminderTitle: reminderTitle,
            reminderNotes: reminderNotes,
            eventStore: eventStore,
            reminderAccess: remindersAccess,
            reminderDefaultCalendar: remindersDefaultCalendar
        )
        return remindersVM
    }
// MARK: - Contacts
    
}

