//
//  ChecklistItem.swift
//  Checklists
//
//  Created by James Fernandez on 8/26/23.
//

import Foundation
import UserNotifications

//satisfies the equatable requirement.
class ChecklistItem: NSObject, Codable { //ChecklistItem will conform to the Codable protocol.
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    //This asks the DataModel object for a new item ID whenever the app creates a new ChecklistItem object and replaces the initial value of -1 with that unique ID.
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    //method will be invoked when you delete an individual ChecklistItem but also when you delete a whole Checklist — because all its ChecklistItems will be destroyed as well, as the array they are in is deallocated.
    deinit {
      removeNotification()
    }
    
    //This compares the due date on the item with the current date.
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            // 2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            // 3
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            // 4
            let request = UNNotificationRequest(
                identifier: "\(itemID)",
                content: content,
                trigger: trigger)
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }
    
    //This removes the local notification for this ChecklistItem, if it exists.
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
