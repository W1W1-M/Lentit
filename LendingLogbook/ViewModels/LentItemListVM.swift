//
//  LentItemStoreVM.swift
//  LendingLogbook
//
//  Created by William Mead on 21/12/2021.
//
import Foundation
/// Lent item list view model
class LentItemListVM: ObservableObject {
// MARK: - Variables
    @Published var lentItemStore: [LentItemModel] {
        // On change reload lent items count & VMs
        didSet{
            lentItemVMs = setLentItemsVMs(for: lentItemStore)
            lentItemsCountText = setLentItemsCount(for: lentItemVMs)
        }
    }
    @Published var lentItemVMs: [LentItemVM]
    @Published var lentItemsCountText: String
    @Published var activeCategory: LentItemCategoryModel {
        didSet{
            lentItemVMs = setLentItemsVMs(for: lentItemStore)
            lentItemsCountText = setLentItemsCount(for: lentItemVMs)
        }
    }
    @Published var activeSort: SortingOrder {
        didSet{
            lentItemVMs = sortedLentItemVMs(for: lentItemVMs)
        }
    }
// MARK: - Init
    /// Custom initialization
    init() {
        // Initialize with empty data
        self.lentItemStore = []
        self.lentItemVMs = []
        self.lentItemsCountText = ""
        self.activeCategory = LentItemCategories.categories[0]
        self.activeSort = SortingOrders.byItemName
        // Initialize lent items view models with lent items from store
        self.lentItemVMs = setLentItemsVMs(for: lentItemStore)
        // Initialize lent items count with lent items from store
        self.lentItemsCountText = "\(self.lentItemStore.count) items"
    }
// MARK: - Functions
    /// Function to set lent item view models with lent item models from store
    /// - Parameter lentItemStore: Array of lent item models
    /// - Returns: Array of lent item view models
    func setLentItemsVMs(for lentItemStore: [LentItemModel]) -> [LentItemVM] {
        var lentItemVMs: [LentItemVM] = []
        // Filter array depending on active category
        if(activeCategory == LentItemCategories.categories[0]) {
            for LentItemModel in self.lentItemStore {
                let lentItemVM = LentItemVM()
                lentItemVM.setLentItemVM(for: LentItemModel)
                lentItemVMs.append(lentItemVM)
            }
        } else {
            for LentItemModel in self.lentItemStore {
                if(LentItemModel.category == activeCategory) {
                    let lentItemVM = LentItemVM()
                    lentItemVM.setLentItemVM(for: LentItemModel)
                    lentItemVMs.append(lentItemVM)
                }
            }
        }
        lentItemVMs = sortedLentItemVMs(for: lentItemVMs)
        return lentItemVMs
    }
    /// Function to sort lent item view models with active sort order
    func sortedLentItemVMs(for lentItemVMs: [LentItemVM]) -> [LentItemVM] {
        var lentItemVMs = lentItemVMs
        // Use switch case to sort array
        switch activeSort {
        case SortingOrders.byItemName:
            lentItemVMs.sort {
                $0.nameText < $1.nameText
            }
        case SortingOrders.byLendDate:
            lentItemVMs.sort {
                $0.lendDate > $1.lendDate
            }
        default:
            lentItemVMs.sort {
                $0.id < $1.id
            }
        }
        return lentItemVMs
    }
    /// Function to set lent items count with lent items views models
    /// - Parameter lentItemVMs: Array of lent item view models
    /// - Returns: String of number of lent items
    func setLentItemsCount(for lentItemVMs: [LentItemVM]) -> String {
        let lentItemsCountText = "\(lentItemVMs.count) items"
        return lentItemsCountText
    }
    /// Function to add a lent item to lent item store
    func addLentItem() {
        let newLentItem = LentItemModel(
            id: UUID(),
            name: "",
            description: "",
            value: 0,
            category: LentItemCategories.categories[5],
            borrower: "",
            lendDate: Date(),
            lendTime: 0.0,
            justAdded: true
        )
        lentItemStore.append(newLentItem)
    }
    /// Function to remove a lent item from lent item store
    /// - Parameter indexSet: Set of indexes to use to delete corresponding array objects
    func removeLentItems(at indexSet: IndexSet) {
        self.lentItemStore.remove(atOffsets: indexSet)
    }
}

struct SortingOrders {
    static var byItemName: SortingOrder = SortingOrder(name: "byItemName")
    static var byLendDate: SortingOrder = SortingOrder(name: "byLendDate")
}

struct SortingOrder: Equatable {
    let id: UUID
    let name: String
    /// <#Description#>
    /// - Parameter name: <#name description#>
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
