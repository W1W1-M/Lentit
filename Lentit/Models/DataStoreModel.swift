//
//  DataStoreModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
// MARK: - Classes
/// Store for lent items
class DataStoreModel: ObservableObject {
// MARK: - Variables
    @Published var storedLoans: [LoanModel]
    @Published var storedItems: [LentItemModel]
    @Published var storedBorrowers: [BorrowerModel]
    init() {
        self.storedLoans = DataStoreModel.sampleLoanData
        self.storedItems = DataStoreModel.sampleLentItemData
        self.storedBorrowers = DataStoreModel.sampleBorrowerData
    }
// MARK: - Functions
    // MARK: - LentItem
    /// Function to  add a new lent item to the store
    /// - Parameter lentItem: Added lent item object
    func createLentItem(newItem lentItem: LentItemModel) {
        storedItems.append(lentItem)
    }
    /// Function to delete a new lent item to the store
    /// - Parameter lentItem: Deleted lent item object
    func deleteLentItem(oldItem lentItem: LentItemModel) {
        if let oldIndex = storedItems.firstIndex(of: lentItem) {
            storedItems.remove(at: oldIndex)
        }
    }
    /// Function to get lent items in store
    /// - Returns: Array of lent item objects
    func readStoredLentItems() -> [LentItemModel] {
        return storedItems
    }
    /// Function to update a lent item in store
    /// - Parameter lentItemVM: Lent item view model containing changes for corresponding lent item model 
    func updateStoredLentItem(for lentItemVM: LentItemVM) {
        // WIP
    }
    /// Function to get number of stored lent items
    /// - Returns: Int of number of lent item objects in store
    func getLentItemStoreCount() -> Int {
        let storeCount = storedItems.count
        return storeCount
    }
    // MARK: - Borrower
    /// <#Description#>
    /// - Parameter borrower: <#borrower description#>
    func createBorrower(newBorrower borrower: BorrowerModel) {
        storedBorrowers.append(borrower)
    }
    /// <#Description#>
    /// - Returns: <#description#>
    func readStoredBorrowers() -> [BorrowerModel] {
        return storedBorrowers
    }
    /// <#Description#>
    /// - Parameter borrowerVM: <#borrowerVM description#>
    func updateBorrower(for borrowerVM: BorrowerVM) {
        // WIP
    }
    /// <#Description#>
    /// - Parameter borrower: <#borrower description#>
    func deleteBorrower(oldBorrower borrower: BorrowerModel) {
        if let oldIndex = storedBorrowers.firstIndex(of: borrower) {
            storedBorrowers.remove(at: oldIndex)
        }
    }
}
// MARK: - Extensions
extension DataStoreModel {
    static var sampleLoanData: [LoanModel] = [
        LoanModel(
            lendDate: Date(),
            lendTime: 600000.0,
            lendExpiry: Date(timeInterval: 600000.0, since: Date()),
            reminder: Date(timeInterval: 600000.0, since: Date()),
            justAdded: false,
            itemId: sampleLentItemData[0].id,
            borrowerId: sampleBorrowerData[0].id
        )
    ]
    static var sampleLentItemData: [LentItemModel] = [
        LentItemModel(
            name: "💿 IronMan bluray",
            description: "Film about some guy in an armored suit",
            value: 10,
            category: ItemCategories.categories[3],
            lendDate: Date(),
            lendTime: 600000.0,
            lendExpiry: Date(timeInterval: 600000.0, since: Date()),
            returnedSold: false,
            justAdded: false,
            borrowerId: sampleBorrowerData[0].id
        ),
        LentItemModel(
            name: "🛡 Vibranium shield",
            description: "An old rusty medievil shield",
            value: 250,
            category: ItemCategories.categories[2],
            lendDate: Date(timeIntervalSince1970: 600000.0),
            lendTime: 600000.0,
            lendExpiry: Date(timeInterval: 600000.0, since: Date(timeIntervalSince1970: 600000.0)),
            returnedSold: false,
            justAdded: false,
            borrowerId: sampleBorrowerData[1].id
        ),
        LentItemModel(
            name: "🕷 Spiderman lego",
            description: "Red lego bricks",
            value: 30,
            category: ItemCategories.categories[6],
            lendDate: Date(),
            lendTime: 1800000.0,
            lendExpiry: Date(timeInterval: 1200000.0, since: Date()),
            returnedSold: false,
            justAdded: false,
            borrowerId: sampleBorrowerData[2].id
        )
    ]
    static var sampleBorrowerData: [BorrowerModel] = [
        BorrowerModel(name: "Sarah"),
        BorrowerModel(name: "Anthony"),
        BorrowerModel(name: "Charly")
    ]
}
