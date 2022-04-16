//
//  DataStoreModel.swift
//  Lentit
//
//  Created by William Mead on 20/12/2021.
//
import Foundation
/// Store for loans, items & borrowers
final class DataStoreModel: ObservableObject {
// MARK: - Properties
    private var storedLoans: [LoanModel]
    private var storedItems: [ItemModel]
    private var storedBorrowers: [BorrowerModel]
    private enum dataStoreErrors: Error {
        case loanNotFound
        case itemNotFound
        case borrowerNotFound
    }
// MARK: - Init & deinit
    init() {
        print("DataStoreModel init ...")
        self.storedLoans = DataStoreModel.sampleLoanData
        self.storedItems = DataStoreModel.sampleItemData
        self.storedBorrowers = DataStoreModel.sampleBorrowerData
    }
    deinit {
        print("... deinit DataStoreModel")
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
    /// Method to get a loan in store
    /// - Parameter id: LoanModel id 
    /// - Returns: LoanModel
    func readStoredLoan(_ id: UUID) throws -> LoanModel {
        if let loan = storedLoans.first(where: { $0.id == id}) {
            return loan
        } else {
            throw dataStoreErrors.loanNotFound
        }
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
    /// Method to get a item in store
    /// - Parameter id: ItemModel id
    /// - Returns: ItemModel
    func readStoredItem(_ id: UUID) throws -> ItemModel {
        if let item = storedItems.first(where: { $0.id == id}) {
            return item
        } else {
            throw dataStoreErrors.itemNotFound
        }
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
    /// Method to get a borrower in store
    /// - Parameter id: BorrowerModel id
    /// - Returns: BorrowerModel
    func readStoredBorrower(_ id: UUID) throws -> BorrowerModel {
        if let borrower = storedBorrowers.first(where: { $0.id == id}) {
            return borrower
        } else {
            throw dataStoreErrors.borrowerNotFound
        }
    }
    /// <#Description#>
    /// - Parameter borrowerVM: <#borrowerVM description#>
    func updateBorrower(for borrowerVM: BorrowerVM) {
        // WIP
    }
    /// <#Description#>
    /// - Parameter borrower: <#borrower description#>
    func deleteBorrower(oldBorrowerId id: UUID) {
        if let oldIndex = storedBorrowers.firstIndex(where: { $0.id == id }) {
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
            ekReminderId: nil,
            reminderDate: nil,
            reminderActive: false,
            returned: false,
            status: StatusModel.current,
            itemId: sampleItemData[0].id,
            borrowerId: sampleBorrowerData[0].id
        ),
        LoanModel(
            loanDate: Date(),
            loanTime: 600000.0,
            ekReminderId: nil,
            reminderDate: nil,
            reminderActive: false,
            returned: false,
            status: StatusModel.current,
            itemId: sampleItemData[1].id,
            borrowerId: sampleBorrowerData[1].id
        ),
        LoanModel(
            loanDate: Date(),
            loanTime: 600000.0,
            ekReminderId: nil,
            reminderDate: nil,
            reminderActive: false,
            returned: true,
            status: StatusModel.finished,
            itemId: sampleItemData[2].id,
            borrowerId: sampleBorrowerData[2].id
        ),
        LoanModel(
            loanDate: Date(),
            loanTime: 600000.0,
            ekReminderId: nil,
            reminderDate: nil,
            reminderActive: false,
            returned: false,
            status: StatusModel.current,
            itemId: sampleItemData[1].id,
            borrowerId: sampleBorrowerData[2].id
        )
    ]
    static var sampleItemData: [ItemModel] = [
        ItemModel(
            name: "IronMan bluray",
            notes: "Film about some guy in an armored suit",
            value: 10,
            category: ItemModel.Category.films,
            status: StatusModel.unavailable,
            loanIds: []
        ),
        ItemModel(
            name: "Vibranium shield",
            notes: "An old rusty medievil shield",
            value: 250,
            category: ItemModel.Category.clothes,
            status: StatusModel.unavailable,
            loanIds: []
        ),
        ItemModel(
            name: "Spiderman lego",
            notes: "Red lego bricks",
            value: 30,
            category: ItemModel.Category.toys,
            status: StatusModel.unavailable,
            loanIds: []
        ),
        ItemModel(
            name: "Bike",
            notes: "Some speedy bicycle",
            value: 100,
            category: ItemModel.Category.other,
            status: StatusModel.available,
            loanIds: []
        ),
        ItemModel(
            name: "Book",
            notes: "A nice book",
            value: 200,
            category: ItemModel.Category.books,
            status: StatusModel.available,
            loanIds: []
        )
    ]
    static var sampleBorrowerData: [BorrowerModel] = [
        BorrowerModel(
            name: "Sarah",
            status: StatusModel.regular,
            loanIds: []
        ),
        BorrowerModel(
            name: "Anthony",
            status: StatusModel.regular,
            loanIds: []
        ),
        BorrowerModel(
            name: "Charly",
            status: StatusModel.regular,
            loanIds: []
        ),
        BorrowerModel(
            name: "Bruno",
            status: StatusModel.regular,
            loanIds: []
        )
    ]
}
