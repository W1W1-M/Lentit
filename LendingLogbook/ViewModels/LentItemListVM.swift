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
// MARK: - Init
    /// Custom initialization
    init() {
        // Initialize with empty data
        self.lentItemStore = []
        self.lentItemVMs = []
        self.lentItemsCountText = ""
        self.activeCategory = LentItemCategories.categories[0]
        // Initialize lent item view models with lent items from store using active category
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
        // Initialize lent items count wiith lent items from store
        self.lentItemsCountText = "\(self.lentItemStore.count) items"
    }
// MARK: - Functions
    /// Function to set lent item view models with lent item models from store
    /// - Parameter lentItemStore: Array of lent item models
    /// - Returns: Array of lent item view models
    func setLentItemsVMs(for lentItemStore: [LentItemModel]) -> [LentItemVM] {
        var lentItemVMs: [LentItemVM] = []
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
        return lentItemVMs
    }
    /// Function to set lent items count with lent items views models
    /// - Parameter lentItemVMs: Array of len item view models
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
            category: LentItemCategories.categories[0],
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
