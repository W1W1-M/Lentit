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
    private let eventStore: EKEventStore
    private var reminderAccess: EKAuthorizationStatus
    private var reminderDefaultCalendar: EKCalendar?
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
    @Published var loanDate: Date
    @Published var ekReminderExists: Bool
    @Published var reminderTitle: String
    @Published var reminderNotes: String
    enum reminderErrors: Error {
        case reminderNotFound
        case calendarNotFound
        case reminderNotSaved
        case reminderNotDeleted
    }
// MARK: - Init & deinit
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
    }
    deinit {
        print("... deinit ReminderVM \(id)")
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
