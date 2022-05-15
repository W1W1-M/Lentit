//
//  RemindersVM.swift
//  Lentit
//
//  Created by William Mead on 07/04/2022.
//

import Foundation
import EventKit
/// Reminder view model
final class RemindersVM: ObservableObject, Identifiable {
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
            if reminderActive {
                checkRemindersAccess()
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
            do {
                try updateReminder()
            } catch {
                print(error)
            }
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
        case reminderNotUpdated
        case alarmsNotFound
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
        print("RemindersVM init ...")
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
        if reminderActive {
            self.ekReminderExists = checkReminderExists(ekReminderId)
        }
    }
    deinit {
        print("... deinit RemindersVM \(id)")
    }
// MARK: - Methods
    func setRemindersVM(
        ekReminderId: String,
        reminderActive: Bool,
        reminderDate: Date
    ) {
        self.id = UUID(uuidString: ekReminderId) ?? UUID()
        self.reminderActive = reminderActive
        self.reminderDate = reminderDate
        self.ekReminderExists = checkReminderExists(ekReminderId)
    }
    func requestRemindersAccess() {
        print("requestRemindersAccess ...")
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted {
                self.reminderAccess = .authorized
                print("Reminders access authorized")
            }
            if let error = error {
                print(error)
                print("Reminders access not authorized")
                return
            }
        }
    }
    func checkRemindersAccess() {
        print("checkRemindersAccess ...")
        self.reminderAccess = EKEventStore.authorizationStatus(for: .reminder)
        if(reminderActive && reminderAccess != .authorized) {
            requestRemindersAccess()
        }
    }
    func getDefaultCalendar() throws -> EKCalendar {
        print("getDefaultCalendar ...")
        checkRemindersAccess()
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
    func updateReminder() throws {
        print("updateReminder \(ekReminderId) ...")
        self.ekReminderExists = checkReminderExists(self.ekReminderId)
        if ekReminderExists {
            do {
                let reminder = try getReminder(ekReminderId)
                let alarm = EKAlarm(absoluteDate: self.reminderDate)
                try deleteAlarms(for: reminder)
                reminder.calendar = self.reminderDefaultCalendar
                reminder.title = self.reminderTitle
                reminder.startDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.loanDate)
                reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.reminderDate)
                reminder.notes = self.reminderNotes
                reminder.addAlarm(alarm)
                try saveReminder(newReminder: reminder)
            } catch {
                print("Reminder update error \(error)")
                throw reminderErrors.reminderNotUpdated
            }
        } else {
            print("Reminder update error")
            throw reminderErrors.reminderNotFound
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
    func deleteAlarms(for reminder: EKReminder) throws {
        print("deleteAlarms ...")
        if let alarms = reminder.alarms {
            for EKAlarm in alarms {
                reminder.removeAlarm(EKAlarm)
            }
        } else {
            print("Alarms not found")
            throw reminderErrors.alarmsNotFound
        }
        
    }
}
