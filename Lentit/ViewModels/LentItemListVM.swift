//
//  LentItemStoreVM.swift
//  Lentit
//
//  Created by William Mead on 21/12/2021.
//
import Foundation
// MARK: - Classes
/// Lent item list view model
class LentItemListVM: ObservableObject {
// MARK: - Variables
    @Published var dataStore: DataStoreModel
    @Published var lentItemVMs: [LentItemVM]
    @Published var borrowerVMs: [BorrowerVM]
    @Published var lentItemsCountText: String
    @Published var activeCategory: LentItemCategoryModel {
        didSet{
            lentItemVMs = setLentItemsVMs(for: dataStore.readStoredLentItems())
            lentItemVMs = filteredLentItemVMs(for: lentItemVMs, by: activeCategory)
            lentItemsCountText = setLentItemsCount(for: lentItemVMs)
        }
    }
    @Published var activeSort: SortingOrder {
        didSet{
            lentItemVMs = sortedLentItemVMs(for: lentItemVMs, by: activeSort)
        }
    }
// MARK: - Init
    /// Custom initialization
    init() {
        // Initialize with empty data
        self.dataStore = DataStoreModel()
        self.lentItemVMs = []
        self.borrowerVMs = []
        self.lentItemsCountText = ""
        self.activeCategory = LentItemCategories.all
        self.activeSort = SortingOrders.byItemName
        // Initialize lent items & borrowers view models with data from store
        self.lentItemVMs = setLentItemsVMs(for: dataStore.readStoredLentItems())
        self.borrowerVMs = setBorrowersVMs(for: dataStore.readStoredBorrowers())
        // Initialize lent items count with lent items from store
        self.lentItemsCountText = "\(self.dataStore.getLentItemStoreCount())"
    }
// MARK: - Functions
    /// Function to set lent item view models with lent item models from store
    /// - Parameter lentItemStore: Array of lent item models
    /// - Returns: Array of lent item view models
    func setLentItemsVMs(for lentItems: [LentItemModel]) -> [LentItemVM] {
        var lentItemVMs: [LentItemVM] = []
        for lentItem in lentItems {
            // Get lent item borrower
            let lentItemBorrower = getLentItemBorrower(for: lentItem)
            // Set lent item view model
            let lentItemVM = LentItemVM()
            lentItemVM.setLentItemVM(for: lentItem, and: lentItemBorrower)
            lentItemVMs.append(lentItemVM)
        }
        // Filter array with active category
        lentItemVMs = filteredLentItemVMs(for: lentItemVMs, by: activeCategory)
        // Sort array with active sort order
        lentItemVMs = sortedLentItemVMs(for: lentItemVMs, by: activeSort)
        return lentItemVMs
    }
    /// <#Description#>
    /// - Parameter borrowers: <#borrowers description#>
    /// - Returns: <#description#>
    func setBorrowersVMs(for borrowers: [BorrowerModel]) -> [BorrowerVM] {
        var borrowersVMs: [BorrowerVM] = []
        for BorrowerModel in borrowers {
            let borrowerVM = BorrowerVM()
            borrowerVM.setBorrowerVM(for: BorrowerModel)
            borrowersVMs.append(borrowerVM)
        }
        borrowersVMs.sort {
            $0.nameText > $1.nameText
        }
        return borrowersVMs
    }
    /// Function to filter lent item view models
    /// - Parameters:
    ///   - lentItemVMs: Lent item view models Array
    ///   - activeCategory: Active LentItemCategoryModel
    /// - Returns: Array of filtered lent items view models
    func filteredLentItemVMs(for lentItemVMs: [LentItemVM], by activeCategory: LentItemCategoryModel) -> [LentItemVM] {
        var filteredLentItemVMs = lentItemVMs
        if(activeCategory == LentItemCategories.all) {
            return filteredLentItemVMs
        } else {
            filteredLentItemVMs = filteredLentItemVMs.filter {
                $0.category == activeCategory
            }
            return filteredLentItemVMs
        }
    }
    /// Function to sort lent item view models with active sort order
    /// - Parameters:
    ///   - lentItemVMs: Lent item view models Array
    ///   - activeSort: Active SortingOrder
    /// - Returns: Array of sorted  lent items view models
    func sortedLentItemVMs(for lentItemVMs: [LentItemVM], by activeSort: SortingOrder) -> [LentItemVM] {
        var sortedLentItemVMs = lentItemVMs
        // Use switch case to sort array
        switch activeSort {
        case SortingOrders.byItemName:
            sortedLentItemVMs.sort {
                $0.nameText < $1.nameText
            }
        case SortingOrders.byLendExpiry:
            sortedLentItemVMs.sort {
                $0.lendExpiry < $1.lendExpiry
            }
        default:
            sortedLentItemVMs.sort {
                $0.id < $1.id
            }
        }
        return sortedLentItemVMs
    }
    /// Function to set lent items count with lent items views models
    /// - Parameter lentItemVMs: Array of lent item view models
    /// - Returns: String of number of lent items
    func setLentItemsCount(for lentItemVMs: [LentItemVM]) -> String {
        let lentItemsCountText = "\(lentItemVMs.count)"
        return lentItemsCountText
    }
    /// Function to add a lent item to lent item store
    func addLentItem() {
        let newLentItem = LentItemModel(
            name: "🆕 New loan",
            description: "",
            value: 0,
            category: LentItemCategories.categories[4],
            lendDate: Date(),
            lendTime: 0.0,
            lendExpiry: Date(),
            returnedSold: false,
            justAdded: true,
            borrowerID: UUID()
        )
        dataStore.createLentItem(newItem: newLentItem)
        // Make sure all categories are shown to see new item
        activeCategory = LentItemCategories.all
        // Reload lent items count & VMs
        lentItemVMs = setLentItemsVMs(for: dataStore.readStoredLentItems())
        lentItemsCountText = setLentItemsCount(for: lentItemVMs)
    }
    /// Function to remove a lent item from lent item store
    /// - Parameter indexSet: Set of indexes to use to delete corresponding array objects
    func removeLentItem(for lentItemVM: LentItemVM) {
        dataStore.deleteLentItem(oldItem: lentItemVM.lentItem)
        // Reload lent items count & VMs
        lentItemVMs = setLentItemsVMs(for: dataStore.readStoredLentItems())
        lentItemsCountText = setLentItemsCount(for: lentItemVMs)
    }
    func addBorrower(named name: String) {
        let newBorrower = BorrowerModel(name: name)
        dataStore.createBorrower(newBorrower: newBorrower)
        borrowerVMs = setBorrowersVMs(for: dataStore.readStoredBorrowers())
    }
    func getLentItemBorrower(for lentItem: LentItemModel) -> BorrowerModel {
        let borrowers = dataStore.readStoredBorrowers()
        var lentItemBorrowerIndex = 0
        if let borrowerIndex = borrowers.firstIndex(where: { $0.id == lentItem.borrowerId}) {
            lentItemBorrowerIndex = borrowerIndex
        }
        let lentItemBorrower: BorrowerModel = borrowers[lentItemBorrowerIndex]
        return lentItemBorrower
    }
}
// MARK: - Structs
struct SortingOrders {
    static var byItemName: SortingOrder = SortingOrder(name: "byItemName")
    static var byLendExpiry: SortingOrder = SortingOrder(name: "byLendExpiry")
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
