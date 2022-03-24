//
//  DataStoreModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
// MARK: - Classes
/// Store for loans, items & borrowers
class DataStoreModel: ObservableObject {
// MARK: - Properties
    private var storedLoans: [LoanModel]
    private var storedItems: [ItemModel]
    private var storedBorrowers: [BorrowerModel]
    init() {
        self.storedLoans = DataStoreModel.sampleLoanData
        self.storedItems = DataStoreModel.sampleItemData
        self.storedBorrowers = DataStoreModel.sampleBorrowerData
    }
// MARK: - Methods
    // MARK: - Loan
    /// Method to add a loan to store
    /// - Parameter loan: LoanModel
    func createLoan(newLoan loan: LoanModel) {
        storedLoans.append(loan)
    }
    /// Method to get loans in store
    /// - Returns: Array of LoanModel
    func readStoredLoans() -> [LoanModel] {
        return storedLoans
    }
    /// Method to delete a loan from store
    /// - Parameter loan: LoanModel
    func deleteLoan(oldLoan loan: LoanModel) {
        if let oldIndex = storedLoans.firstIndex(of: loan) {
            storedLoans.remove(at: oldIndex)
        }
    }
// MARK: - Item
    /// Method to add an item to store
    /// - Parameter item: ItemModel
    func createItem(newItem item: ItemModel) {
        storedItems.append(item)
    }
    /// Method to get items in store
    /// - Returns: Array of ItemModel
    func readStoredItems() -> [ItemModel] {
        return storedItems
    }
    /// Method to update an item in store
    /// - Parameter itemVM: ItemVM
    func updateStoredItem(for itemVM: ItemVM) {
        // WIP
    }
    /// Method to delete an item from store
    /// - Parameter item: ItemModel
    func deleteItem(oldItem item: ItemModel) {
        if let oldIndex = storedItems.firstIndex(of: item) {
            storedItems.remove(at: oldIndex)
        }
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
            loanDate: Date(),
            loanTime: 600000.0,
            reminder: Date(timeInterval: 600000.0, since: Date()),
            reminderActive: false,
            returned: false,
            status: LoanModel.Status.current,
            itemId: sampleItemData[0].id,
            borrowerId: sampleBorrowerData[0].id
        ),
        LoanModel(
            loanDate: Date(),
            loanTime: 600000.0,
            reminder: Date(timeInterval: 600000.0, since: Date()),
            reminderActive: true,
            returned: false,
            status: LoanModel.Status.current,
            itemId: sampleItemData[1].id,
            borrowerId: sampleBorrowerData[1].id
        ),
        LoanModel(
            loanDate: Date(),
            loanTime: 600000.0,
            reminder: Date(timeInterval: 600000.0, since: Date()),
            reminderActive: false,
            returned: true,
            status: LoanModel.Status.finished,
            itemId: sampleItemData[2].id,
            borrowerId: sampleBorrowerData[2].id
        ),
        LoanModel(
            loanDate: Date(),
            loanTime: 600000.0,
            reminder: Date(timeInterval: 600000.0, since: Date()),
            reminderActive: true,
            returned: false,
            status: LoanModel.Status.current,
            itemId: sampleItemData[1].id,
            borrowerId: sampleBorrowerData[2].id
        )
    ]
    static var sampleItemData: [ItemModel] = [
        ItemModel(
            name: "IronMan bluray",
            description: "Film about some guy in an armored suit",
            value: 10,
            category: ItemModel.Category.clothes,
            status: ItemModel.Status.unavailable,
            loanIds: []
        ),
        ItemModel(
            name: "Vibranium shield",
            description: "An old rusty medievil shield",
            value: 250,
            category: ItemModel.Category.clothes,
            status: ItemModel.Status.unavailable,
            loanIds: []
        ),
        ItemModel(
            name: "Spiderman lego",
            description: "Red lego bricks",
            value: 30,
            category: ItemModel.Category.toys,
            status: ItemModel.Status.unavailable,
            loanIds: []
        ),
        ItemModel(
            name: "Bike",
            description: "",
            value: 100,
            category: ItemModel.Category.other,
            status: ItemModel.Status.available,
            loanIds: []
        ),
        ItemModel(
            name: "Book",
            description: "",
            value: 200,
            category: ItemModel.Category.other,
            status: ItemModel.Status.available,
            loanIds: []
        )
    ]
    static var sampleBorrowerData: [BorrowerModel] = [
        BorrowerModel(
            name: "Sarah",
            status: BorrowerModel.Status.regular,
            loanIds: []
        ),
        BorrowerModel(
            name: "Anthony",
            status: BorrowerModel.Status.regular,
            loanIds: []
        ),
        BorrowerModel(
            name: "Charly",
            status: BorrowerModel.Status.regular,
            loanIds: []
        ),
        BorrowerModel(
            name: "Bruno",
            status: BorrowerModel.Status.regular,
            loanIds: []
        )
    ]
}
