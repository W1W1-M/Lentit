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
    private(set) var loanItem: ItemModel
    private(set) var loanBorrower: BorrowerModel
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
    @Published var loanBorrowerName: String
    @Published var loanItemName: String
    @Published var loanItemCategory: ItemModel.Category
    @Published var reminderVM: ReminderVM
// MARK: - Init
    init() {
        print("LoanVM init ...")
        self.loan = LoanModel.defaultData
        self.loanItem = ItemModel.defaultData
        self.loanBorrower = BorrowerModel.defaultData
        self.id = LoanModel.defaultData.id
        self.loanDate = LoanModel.defaultData.loanDate
        self.loanDateText = "\(LoanModel.defaultData.loanDate)"
        self.returned = LoanModel.defaultData.returned
        self.status = LoanModel.defaultData.status
        self.loanBorrowerName = BorrowerModel.defaultData.name
        self.loanItemName = ItemModel.defaultData.name
        self.loanItemCategory = ItemModel.defaultData.category
        self.reminderVM = ReminderVM(
            loan: LoanModel.defaultData,
            reminderTitle: "\(ItemModel.Category.other.emoji) Loan to \(BorrowerModel.defaultData.name)",
            reminderNotes: ItemModel.defaultData.name
        )
        //
        self.loanDateText = setLoanDateText(for: loanDate)
        print("... init LoanVM \(id)")
    }
// MARK: - Methods
    func setLoanVM(from loan: LoanModel, _ loanItem: ItemModel, _ loanBorrower: BorrowerModel) {
        print("setLoanVM ...")
        self.loan = loan
        self.loanItem = loanItem
        self.loanBorrower = loanBorrower
        self.id = loan.id
        self.loanDate = loan.loanDate
        self.returned = loan.returned
        self.status = loan.status
        self.loanBorrowerName = loanBorrower.name
        self.loanItemName = loanItem.name
        self.loanItemCategory = loanItem.category
        self.loan = loan
        self.reminderVM = ReminderVM(
            loan: loan,
            reminderTitle: "\(loanItem.category.emoji) Loan to \(loanBorrower.name)",
            reminderNotes: loanItem.name
        )
        print("... setLoanVM \(id)")
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
    func setLoanBorrower(to newBorrower: BorrowerModel) {
        self.loanBorrower = newBorrower
        self.loanBorrower.addLoanId(with: self.id)
        self.loan.updateBorrowerId(self.loanBorrower.id)
    }
    func setLoanItem(to newItem: ItemModel) {
        self.loanItem = newItem
        self.loanItem.addLoanId(with: self.id)
        self.loan.updateItemId(self.loanItem.id)
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
        private(set) var loan: LoanModel
        private(set) var id: UUID
        @Published var reminder: EKReminder {
            didSet {
                self.loan.reminder = reminder
                self.reminderDateText = setReminderDateText(for: reminder.dueDateComponents?.date ?? reminderDate)
            }
        }
        @Published var reminderActive: Bool {
            didSet {
                self.loan.reminderActive = reminderActive
                if(reminderActive) {
                    checkReminderAccess()
                    setDefaultCalendar()
                    self.ekReminderExists = checkReminderExists(reminder.calendarItemIdentifier)
                }
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
            loan: LoanModel,
            reminderTitle: String,
            reminderNotes: String
        ) {
            print("ReminderVM init ...")
            self.loan = loan
            self.id = UUID()
            self.reminder = loan.reminder ?? EKReminder()
            self.reminderActive = loan.reminderActive
            self.reminderDate = Date()
            self.reminderDateText = ""
            self.eventStore = EKEventStore()
            self.reminderAccess = EKEventStore.authorizationStatus(for: .reminder)
            self.loanDate = loan.loanDate
            self.ekReminderExists = false
            self.reminderTitle = reminderTitle
            self.reminderNotes = reminderNotes
            self.reminderDefaultCalendar = nil
            //
            self.id = UUID(uuidString: reminder.calendarItemIdentifier) ?? UUID()
            self.reminderDate = reminder.dueDateComponents?.date ?? Date(timeInterval: 30*24*60*60, since: loanDate)
            self.reminderDateText = setReminderDateText(for: reminderDate)
            if(reminderActive) {
                self.ekReminderExists = checkReminderExists(reminder.calendarItemIdentifier)
            }
            print("... init ReminderVM \(id)")
        }
// MARK: - Methods
        func setReminderVM(
            reminder: EKReminder,
            reminderActive: Bool
        ) {
            self.id = UUID(uuidString: reminder.calendarItemIdentifier) ?? UUID()
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
        func setDefaultCalendar() {
            do {
                self.reminderDefaultCalendar = try getDefaultCalendar()
                print("Default calendar set")
            } catch {
                print("Default calendar error: \(error)")
            }
        }
        func createReminder() throws {
            checkReminderAccess()
            setDefaultCalendar()
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
                self.ekReminderExists = true
            } catch {
                print(error)
                throw reminderErrors.reminderNotSaved
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
        func deleteReminder() throws {
            print("deleteReminder ...")
            do {
                let oldReminder = try getReminder(reminder.calendarItemIdentifier)
                try eventStore.remove(oldReminder, commit: true)
                self.reminderActive = false
                resetReminder()
                print("Reminder \(oldReminder.calendarItemIdentifier) deleted")
            } catch {
                print("Reminder delete error \(error)")
                throw reminderErrors.reminderNotDeleted
            }
            print("... deleteReminder")
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
