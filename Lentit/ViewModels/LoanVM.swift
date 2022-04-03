//
//  LoanVM.swift
//  Lentit
//
//  Created by William Mead on 18/01/2022.
//

import Foundation
import EventKit
/// Loan view model
class LoanVM: ObservableObject, Identifiable {
// MARK: - Properties
    private(set) var loan: LoanModel
    private(set) var id: UUID
    @Published var loanDate: Date {
        didSet{
            loan.loanDate = self.loanDate
            loanDateText = setLoanDateText(for: loanDate)
        }
    }
    @Published var loanDateText: String
    @Published var returned: Bool {
        didSet{
            loan.returned = self.returned
            setReturnedLoanStatus()
        }
    }
    @Published var status: LoanModel.Status {
        didSet{
            loan.status = self.status
        }
    }
    @Published var itemVM: ItemVM
    @Published var borrowerVM: BorrowerVM
    @Published var reminderVM: ReminderVM
    @Published var editDisabled: Bool
// MARK: - Init
    init() {
        self.loan = LoanModel.defaultData
        self.id = LoanModel.defaultData.id
        self.loanDate = LoanModel.defaultData.loanDate
        self.loanDateText = "\(LoanModel.defaultData.loanDate)"
        self.returned = LoanModel.defaultData.returned
        self.status = LoanModel.defaultData.status
        self.itemVM = ItemVM()
        self.borrowerVM = BorrowerVM()
        self.reminderVM = ReminderVM(
            reminder: EKReminder(),
            reminderActive: LoanModel.defaultData.reminderActive,
            loanDate: LoanModel.defaultData.loanDate,
            reminderTitle: "\(ItemModel.Category.other.emoji) Loan to \(BorrowerModel.defaultData.name)",
            reminderNotes: ItemModel.defaultData.name
        )
        self.editDisabled = true
        //
        self.loanDateText = setLoanDateText(for: loanDate)
    }
// MARK: - Methods
    func setLoanVM(from loanModel: LoanModel, _ itemVM: ItemVM, _ borrowerVM: BorrowerVM) {
        self.loan = loanModel
        self.id = loanModel.id
        self.loanDate = loanModel.loanDate
        self.returned = loanModel.returned
        self.status = loanModel.status
        self.itemVM = itemVM
        self.borrowerVM = borrowerVM
        self.reminderVM.reminder = loanModel.reminder ?? EKReminder()
        self.reminderVM.reminderActive = loanModel.reminderActive
        self.loanDate = loanModel.loanDate
        self.reminderVM.reminderTitle = "\(itemVM.category.emoji) Loan to \(borrowerVM.nameText)"
        self.reminderVM.reminderNotes = itemVM.nameText
        self.editDisabled = true
    }
    func setLoanDateText(for loanDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let loanDateText: String = dateFormat.string(from: loanDate)
        return loanDateText
    }
    func setLoanExpiryText(for loanExpiry: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = .medium
        let loanExpiryText: String = dateFormat.string(from: loanExpiry)
        return loanExpiryText
    }
    func setLoanTimeText(for loanTime: TimeInterval) -> String {
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .short
        timeFormat.allowedUnits = [.day, .month, .year]
        if let loanTime = timeFormat.string(from: loanTime) {
            let loanTimeText = loanTime
            return loanTimeText
        } else {
            let loanTimeText = ""
            return loanTimeText
        }
    }
    func setLoanTime(from loanDate: Date, to loanExpiry: Date) -> TimeInterval {
        let loanTime = loanExpiry.timeIntervalSince(loanDate)
        return loanTime
    }
    func setLoanBorrower(to newBorrowerVM: BorrowerVM) {
        self.borrowerVM = newBorrowerVM
        self.borrowerVM.updateBorrowerLoans(with: self.id)
        self.loan.borrowerId = self.borrowerVM.id
    }
    func setLoanItem(to newItemVM: ItemVM) {
        self.itemVM = newItemVM
        self.itemVM.updateItemLoans(with: self.id)
        self.loan.itemId = self.itemVM.id
    }
    func setReturnedLoanStatus() {
        if(returned) {
            self.status = LoanModel.Status.finished
        } else if(!returned && status == LoanModel.Status.finished) {
            self.status = LoanModel.Status.current
        }
    }
}

extension LoanVM {
    class ReminderVM {
// MARK: - Properties
        @Published var reminder: EKReminder {
            didSet {
                self.reminderDateText = setReminderDateText(for: reminder.dueDateComponents?.date ?? reminderDate)
                self.ekReminderExists = checkReminderExists(reminder.calendarItemIdentifier)
            }
        }
        @Published var reminderActive: Bool {
            didSet {
                checkReminderAccess()
                self.ekReminderExists = checkReminderExists(reminder.calendarItemIdentifier)
            }
        }
        @Published var reminderDate: Date
        @Published var reminderDateText: String
        private let eventStore: EKEventStore
        private var reminderAccess: EKAuthorizationStatus
        var loanDate: Date
        @Published var ekReminderExists: Bool
        @Published var reminderTitle: String
        @Published var reminderNotes: String
        private var reminderDefaultCalendar: EKCalendar?
        enum reminderErrors: Error {
            case reminderNotFound
            case calendarNotFound
            case reminderNotSaved
            case reminderNotDeleted
        }
// MARK: - Custom initializer
        init(
            reminder: EKReminder,
            reminderActive: Bool,
            loanDate: Date,
            reminderTitle: String,
            reminderNotes: String
        ) {
            self.reminder = reminder
            self.reminderActive = reminderActive
            self.reminderDate = Date()
            self.reminderDateText = ""
            self.eventStore = EKEventStore()
            self.reminderAccess = EKEventStore.authorizationStatus(for: .reminder)
            self.loanDate = loanDate
            self.ekReminderExists = false
            self.reminderTitle = reminderTitle
            self.reminderNotes = reminderNotes
            do {
                try self.reminderDefaultCalendar = getDefaultCalendar()
                print("Default calendar set")
            } catch {
                print("Default calendar error: \(error)")
            }
            //
            self.ekReminderExists = checkReminderExists(reminder.calendarItemIdentifier)
            self.reminderDate = reminder.dueDateComponents?.date ?? Date(timeInterval: 30*24*60*60, since: loanDate)
            self.reminderDateText = setReminderDateText(for: reminderDate)
        }
// MARK: - Methods
        func setReminderVM(
            reminder: EKReminder,
            reminderActive: Bool
        ) {
            self.reminder = reminder
            self.reminderActive = reminderActive
            self.reminderDate = reminder.dueDateComponents?.date ?? Date(timeInterval: 30*24*60*60, since: loanDate)
            self.ekReminderExists = checkReminderExists(reminder.calendarItemIdentifier)
        }
        func requestReminderAccess() {
            eventStore.requestAccess(to: .reminder) { granted, error in
                if granted {
                    self.reminderAccess = .authorized
                    print("Reminder access authorized")
                }
                if let error = error {
                    print(error)
                    print("Reminder access not authorized")
                    return
                }
            }
        }
        func checkReminderAccess() {
            self.reminderAccess = EKEventStore.authorizationStatus(for: .reminder)
            if(reminderActive && reminderAccess != .authorized) {
                requestReminderAccess()
            }
            print("Reminder access level: \(reminderAccess.rawValue)")
        }
        func getDefaultCalendar() throws -> EKCalendar {
            if let defaultCalendar = self.eventStore.defaultCalendarForNewReminders() {
                return defaultCalendar
            } else {
                throw reminderErrors.calendarNotFound
            }
        }
        func createReminder() throws {
            let newReminder = EKReminder(eventStore: eventStore)
            let newAlarm = EKAlarm(absoluteDate: self.reminderDate)
            newReminder.calendar = self.reminderDefaultCalendar
            newReminder.title = self.reminderTitle
            newReminder.startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.loanDate)
            newReminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.reminderDate)
            newReminder.notes = self.reminderNotes
            newReminder.addAlarm(newAlarm)
            do {
                try saveReminder(newReminder: newReminder)
                self.reminder = newReminder
            } catch {
                print(error)
            }
        }
        func saveReminder(newReminder: EKReminder) throws {
            do {
                try eventStore.save(newReminder, commit: true)
                print("Reminder \(newReminder.calendarItemIdentifier) saved")
            } catch {
                print("Reminder save error: \(error)")
                throw reminderErrors.reminderNotSaved
            }
        }
        func deleteReminder(oldReminder: EKReminder) throws {
            do {
                try eventStore.remove(oldReminder, commit: true)
                self.reminderActive = false
                resetReminder()
                print("Reminder \(oldReminder.calendarItemIdentifier) deleted")
            } catch {
                print("Reminder delete error \(error)")
                throw reminderErrors.reminderNotDeleted
            }
        }
        func getReminder(_ reminderId: String) throws -> EKReminder {
            if let ekReminder = eventStore.calendarItem(withIdentifier: reminderId) {
                print("Reminder \(reminderId) found")
                return ekReminder as! EKReminder
            } else {
                print("Reminder \(reminderId) not found")
                throw reminderErrors.reminderNotFound
            }
        }
        func resetReminder() {
            self.reminder = EKReminder()
        }
        func checkReminderExists(_ reminderId: String) -> Bool {
            if eventStore.calendarItem(withIdentifier: reminderId) != nil {
                print("Reminder \(reminderId) found")
                return true
            } else {
                print("Reminder \(reminderId) not found")
                return false
            }
        }
        func setReminderDateText(for reminderDate: Date) -> String {
            let dateFormat = DateFormatter()
            dateFormat.locale = .current
            dateFormat.dateStyle = .medium
            let reminderDateText: String = dateFormat.string(from: reminderDate)
            return reminderDateText
        }
    }
}
