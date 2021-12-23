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
            lentItemsCountText = setLentItemsCount(for: lentItemStore)
            lentItemVMs = setLentItemsVMs(for: lentItemStore)
        }
    }
    @Published var lentItemVMs: [LentItemVM]
    @Published var lentItemsCountText: String
// MARK: - Init
    /// Custom initialization
    init() {
        // Initialize with empty data
        self.lentItemStore = []
        self.lentItemVMs = []
        self.lentItemsCountText = ""
        // Initialize lent item view models with lent items from store
        for LentItemModel in self.lentItemStore {
            let lentItemVM = LentItemVM()
            lentItemVM.setLentItemVM(for: LentItemModel)
            lentItemVMs.append(lentItemVM)
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
        for LentItemModel in lentItemStore {
            let lentItemVM = LentItemVM()
            lentItemVM.setLentItemVM(for: LentItemModel)
            lentItemVMs.append(lentItemVM)
        }
        return lentItemVMs
    }
    /// Function to set lent items count with lent items from store
    /// - Parameter lentItemStore: Array of len item models
    /// - Returns: String of number of lent items
    func setLentItemsCount(for lentItemStore: [LentItemModel]) -> String {
        let lentItemsCountText = "\(lentItemStore.count) items"
        return lentItemsCountText
    }
    /// Function to add a lent item to lent item store
    func addLentItem() {
        let newLentItem = LentItemModel(
            id: UUID(),
            name: "name",
            emoji: "😀",
            description: "description",
            value: 10.0,
            category: "category",
            borrower: "borrower",
            lendDate: Date(),
            lendTime: 120000.0
        )
        lentItemStore.append(newLentItem)
    }
    /// Function to remove a lent item from lent item store
    /// - Parameter indexSet: Set of indexes to use to delete corresponding array objects
    func removeLentItems(at indexSet: IndexSet) {
        self.lentItemStore.remove(atOffsets: indexSet)
    }
}
