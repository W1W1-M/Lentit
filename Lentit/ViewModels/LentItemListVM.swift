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
    @Published var lentItemStore: LentItemStoreModel
    @Published var lentItemVMs: [LentItemVM]
    @Published var lentItemsCountText: String
    @Published var activeCategory: LentItemCategoryModel {
        didSet{
            lentItemVMs = setLentItemsVMs(for: lentItemStore)
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
        self.lentItemStore = LentItemStoreModel()
        self.lentItemVMs = []
        self.lentItemsCountText = ""
        self.activeCategory = LentItemCategories.all
        self.activeSort = SortingOrders.byItemName
        // Initialize lent items view models with lent items from store
        self.lentItemVMs = setLentItemsVMs(for: lentItemStore)
        // Initialize lent items count with lent items from store
        self.lentItemsCountText = "\(self.lentItemStore.getLentItemStoreCount())"
    }
// MARK: - Functions
    /// Function to set lent item view models with lent item models from store
    /// - Parameter lentItemStore: Array of lent item models
    /// - Returns: Array of lent item view models
    func setLentItemsVMs(for lentItemStore: LentItemStoreModel) -> [LentItemVM] {
        var lentItemVMs: [LentItemVM] = []
        let lentItems: [LentItemModel] = lentItemStore.getStoredLentItems()
        for LentItemModel in lentItems {
            let lentItemVM = LentItemVM()
            lentItemVM.setLentItemVM(for: LentItemModel)
            lentItemVMs.append(lentItemVM)
        }
        // Filter array with active category
        lentItemVMs = filteredLentItemVMs(for: lentItemVMs, by: activeCategory)
        // Sort array with active sort order
        lentItemVMs = sortedLentItemVMs(for: lentItemVMs, by: activeSort)
        return lentItemVMs
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
            id: UUID(),
            name: "",
            description: "",
            value: 0,
            category: LentItemCategories.categories[4],
            borrower: "",
            lendDate: Date(),
            lendTime: 0.0,
            lendExpiry: Date(),
            justAdded: true
        )
        lentItemStore.addLentItem(newItem: newLentItem)
        // Make sure all categories are shown to see new item
        activeCategory = LentItemCategories.all
        // Reload lent items count & VMs
        lentItemVMs = setLentItemsVMs(for: lentItemStore)
        lentItemsCountText = setLentItemsCount(for: lentItemVMs)
    }
    /// Function to remove a lent item from lent item store
    /// - Parameter indexSet: Set of indexes to use to delete corresponding array objects
    func removeLentItem(for lentItemVM: LentItemVM) {
        lentItemStore.removeLentItem(oldItem: lentItemVM.lentItem)
        // Reload lent items count & VMs
        lentItemVMs = setLentItemsVMs(for: lentItemStore)
        lentItemsCountText = setLentItemsCount(for: lentItemVMs)
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
