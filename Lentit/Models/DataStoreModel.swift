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
    @Published var storedItems: [ItemModel]
    @Published var storedBorrowers: [BorrowerModel]
    init() {
        self.storedLoans = DataStoreModel.sampleLoanData
        self.storedItems = DataStoreModel.sampleItemData
        self.storedBorrowers = DataStoreModel.sampleBorrowerData
    }
// MARK: - Functions
    // MARK: - Loan
    func createLoan(newLoan loan: LoanModel) {
        storedLoans.append(loan)
    }
    /// <#Description#>
    /// - Returns: <#description#>
    func readStoredLoans() -> [LoanModel] {
        return storedLoans
    }
    /// <#Description#>
    /// - Parameter loan: <#loan description#>
    func deleteLoan(oldLoan loan: LoanModel) {
        if let oldIndex = storedLoans.firstIndex(of: loan) {
            storedLoans.remove(at: oldIndex)
        }
    }
// MARK: - Item
    /// Function to  add a new lent item to the store
    /// - Parameter item: Added lent item object
    func createItem(newItem item: ItemModel) {
        storedItems.append(item)
    }
    /// Function to delete a new lent item to the store
    /// - Parameter item: Deleted lent item object
    func deleteItem(oldItem item: ItemModel) {
        if let oldIndex = storedItems.firstIndex(of: item) {
            storedItems.remove(at: oldIndex)
        }
    }
    /// Function to get lent items in store
    /// - Returns: Array of lent item objects
    func readStoredItems() -> [ItemModel] {
        return storedItems
    }
    /// Function to update a lent item in store
    /// - Parameter itemVM: Lent item view model containing changes for corresponding lent item model 
    func updateStoredItem(for itemVM: ItemVM) {
        // WIP
    }
    /// Function to get number of stored lent items
    /// - Returns: Int of number of lent item objects in store
    func getItemStoreCount() -> Int {
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
    static var defaultLoanData: LoanModel = LoanModel(
        id: UUID(),
        loanDate: Date(),
        loanTime: 100000.0,
        loanExpiry: Date(),
        reminder: Date(),
        returned: false,
        status: LoanStatus.new,
        itemId: UUID(),
        borrowerId: UUID()
    )
    static var defaultItemData: ItemModel = ItemModel(
        id: UUID(),
        name: "Unknown item",
        description: "Unknown description",
        value: 100,
        category: ItemCategories.categories[4],
        status: ItemStatus.new,
        loanIds: [UUID()]
    )
    static var defaultBorrowerData: BorrowerModel = BorrowerModel(
        id: UUID(),
        name: "Unknown borrower",
        justAdded: false,
        loanIds: [UUID()]
    )
    static var sampleLoanData: [LoanModel] = [
        LoanModel(
            id: UUID(),
            loanDate: Date(),
            loanTime: 600000.0,
            loanExpiry: Date(timeInterval: 600000.0, since: Date()),
            reminder: Date(timeInterval: 600000.0, since: Date()),
            returned: false,
            status: LoanStatus.current,
            itemId: sampleItemData[0].id,
            borrowerId: sampleBorrowerData[0].id
        ),
        LoanModel(
            id: UUID(),
            loanDate: Date(),
            loanTime: 600000.0,
            loanExpiry: Date(timeInterval: 600000.0, since: Date()),
            reminder: Date(timeInterval: 600000.0, since: Date()),
            returned: false,
            status: LoanStatus.current,
            itemId: sampleItemData[1].id,
            borrowerId: sampleBorrowerData[1].id
        ),
        LoanModel(
            id: UUID(),
            loanDate: Date(),
            loanTime: 600000.0,
            loanExpiry: Date(timeInterval: 600000.0, since: Date()),
            reminder: Date(timeInterval: 600000.0, since: Date()),
            returned: true,
            status: LoanStatus.finished,
            itemId: sampleItemData[2].id,
            borrowerId: sampleBorrowerData[2].id
        ),
        LoanModel(
            id: UUID(),
            loanDate: Date(),
            loanTime: 600000.0,
            loanExpiry: Date(timeInterval: 600000.0, since: Date()),
            reminder: Date(timeInterval: 600000.0, since: Date()),
            returned: false,
            status: LoanStatus.current,
            itemId: sampleItemData[1].id,
            borrowerId: sampleBorrowerData[2].id
        )
    ]
    static var sampleItemData: [ItemModel] = [
        ItemModel(
            id: UUID(),
            name: "💿 IronMan bluray",
            description: "Film about some guy in an armored suit",
            value: 10,
            category: ItemCategories.categories[3],
            status: ItemStatus.unavailable,
            loanIds: []
        ),
        ItemModel(
            id: UUID(),
            name: "🛡 Vibranium shield",
            description: "An old rusty medievil shield",
            value: 250,
            category: ItemCategories.categories[2],
            status: ItemStatus.unavailable,
            loanIds: []
        ),
        ItemModel(
            id: UUID(),
            name: "🕷 Spiderman lego",
            description: "Red lego bricks",
            value: 30,
            category: ItemCategories.categories[6],
            status: ItemStatus.unavailable,
            loanIds: []
        )
    ]
    static var sampleBorrowerData: [BorrowerModel] = [
        BorrowerModel(
            id: UUID(),
            name: "Sarah",
            justAdded: false,
            loanIds: []
        ),
        BorrowerModel(
            id: UUID(),
            name: "Anthony",
            justAdded: false,
            loanIds: []
        ),
        BorrowerModel(
            id: UUID(),
            name: "Charly",
            justAdded: false,
            loanIds: []
        )
    ]
}
