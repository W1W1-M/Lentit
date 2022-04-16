//
//  ReminderVM.swift
//  Lentit
//
//  Created by William Mead on 07/04/2022.
//

import Foundation
import EventKit
/// Reminder view model
class ReminderVM: ObservableObject, Identifiable {
// MARK: - Properties
    private(set) var loan: LoanModel
    private(set) var id: UUID
    internal var eventStore: EKEventStore
    internal var reminderAccess: EKAuthorizationStatus {
        didSet {
            print("Reminder access level: \(reminderAccess.rawValue)")
        }
    }
    internal var reminderDefaultCalendar: EKCalendar?
    @Published var reminderActive: Bool {
        didSet {
            self.loan.reminderActive = reminderActive
            if(reminderActive) {
                checkReminderAccess()
            } else {
                resetReminder()
            }
        }
    }
    @Published var ekReminderId: String {
        didSet {
            self.loan.ekReminderId = ekReminderId
        }
    }
    @Published var reminderDate: Date {
        didSet {
            self.loan.reminderDate = reminderDate
            self.reminderDateText = setReminderDateText(for: reminderDate)
        }
    }
    @Published var reminderDateText: String
    @Published var loanDate: Date
    @Published var ekReminderExists: Bool
    @Published var reminderTitle: String
    @Published var reminderNotes: String
    enum reminderErrors: Error {
        case reminderNotFound
        case defaultCalendarNotSet
        case reminderNotSaved
        case reminderNotDeleted
    }
// MARK: - Init & deinit
    init(
        loan: LoanModel,
        reminderTitle: String,
        reminderNotes: String,
        eventStore: EKEventStore,
        reminderAccess: EKAuthorizationStatus,
        reminderDefaultCalendar: EKCalendar?
    ) {
        print("ReminderVM init ...")
        self.loan = loan
        self.id = UUID()
        self.reminderActive = loan.reminderActive
        self.ekReminderId = loan.ekReminderId ?? ""
        self.reminderDate = loan.reminderDate ?? Date(timeInterval: 30*24*60*60, since: loan.loanDate)
        self.reminderDateText = ""
        self.eventStore = eventStore
        self.reminderAccess = reminderAccess
        self.loanDate = loan.loanDate
        self.ekReminderExists = false
        self.reminderTitle = reminderTitle
        self.reminderNotes = reminderNotes
        self.reminderDefaultCalendar = reminderDefaultCalendar
        //
        self.id = UUID(uuidString: ekReminderId) ?? UUID()
        self.reminderDateText = setReminderDateText(for: reminderDate)
        if(reminderActive) {
            self.ekReminderExists = checkReminderExists(ekReminderId)
        }
    }
    deinit {
        print("... deinit ReminderVM \(id)")
    }
// MARK: - Methods
    func setReminderVM(
        ekReminderId: String,
        reminderActive: Bool,
        reminderDate: Date
    ) {
        self.id = UUID(uuidString: ekReminderId) ?? UUID()
        self.reminderActive = reminderActive
        self.reminderDate = reminderDate
        self.ekReminderExists = checkReminderExists(ekReminderId)
    }
    func requestReminderAccess() {
        print("requestReminderAccess ...")
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
        print("checkReminderAccess ...")
        self.reminderAccess = EKEventStore.authorizationStatus(for: .reminder)
        if(reminderActive && reminderAccess != .authorized) {
            requestReminderAccess()
        }
    }
    func getDefaultCalendar() throws -> EKCalendar {
        print("getDefaultCalendar ...")
        checkReminderAccess()
        resetEventStore()
        if let defaultCalendar = self.eventStore.defaultCalendarForNewReminders() {
            print("... getDefaultCalendar \(defaultCalendar.title)")
            return defaultCalendar
        } else {
            throw reminderErrors.defaultCalendarNotSet
        }
    }
    func setDefaultCalendar() throws {
        do {
            self.reminderDefaultCalendar = try getDefaultCalendar()
            print("Default calendar set \(reminderDefaultCalendar?.title ?? "")")
        } catch {
            print("Default calendar error: \(error)")
            throw error
        }
    }
    func createReminder() throws {
        print("createReminder ...")
        do {
            try setDefaultCalendar()
            let newReminder = EKReminder(eventStore: eventStore)
            let newAlarm = EKAlarm(absoluteDate: self.reminderDate)
            newReminder.calendar = self.reminderDefaultCalendar
            newReminder.title = self.reminderTitle
            newReminder.startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.loanDate)
            newReminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.reminderDate)
            newReminder.notes = self.reminderNotes
            newReminder.addAlarm(newAlarm)
            try saveReminder(newReminder: newReminder)
            self.ekReminderId = newReminder.calendarItemIdentifier
            self.ekReminderExists = checkReminderExists(self.ekReminderId)
            print("... createReminder \(ekReminderId)")
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
            let oldReminder = try getReminder(ekReminderId)
            try eventStore.remove(oldReminder, commit: true)
            self.ekReminderExists = checkReminderExists(ekReminderId)
            self.reminderActive = false
            print("Reminder \(oldReminder.calendarItemIdentifier) deleted")
        } catch {
            print("Reminder delete error \(error)")
            self.ekReminderExists = checkReminderExists(ekReminderId)
            throw reminderErrors.reminderNotDeleted
        }
        
        print("... deleteReminder \(ekReminderId)")
    }
    func getReminder(_ reminderId: String) throws -> EKReminder {
        print("getReminder ...")
        if let ekReminder = eventStore.calendarItem(withIdentifier: reminderId) {
            print("Reminder \(reminderId) found")
            return ekReminder as! EKReminder
        } else {
            print("Reminder \(reminderId) not found")
            throw reminderErrors.reminderNotFound
        }
    }
    func resetReminder() {
        do {
            try deleteReminder()
        } catch {
            print(error)
        }
        self.ekReminderId = ""
        self.reminderDate = Date()
    }
    func checkReminderExists(_ reminderId: String) -> Bool {
        print("checkReminderExists ...")
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
    func resetEventStore() {
        print("resetEventStore ...")
        self.eventStore = EKEventStore()
    }
}
