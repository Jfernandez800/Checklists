//
//  DataModel.swift
//  Checklists
//
//  Created by James Fernandez on 9/7/23.
//

import Foundation

//defines the new DataModel object and gives it a lists property.
class DataModel {
    
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK: - Data Saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // You encode lists instead of "items"
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // You decode to an object of [Checklist] type to lists
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    //creates a new Dictionary instance and add the value -1 for the key “ChecklistIndex”.
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //declare a new instance variable indexOfSelectedChecklist of type Int.
    var indexOfSelectedChecklist: Int {
        //code in the get block is performed. And when the app tries to put a new value into indexOfSelectedChecklist, the set block is performed.
        get {
            return UserDefaults.standard.integer(
                forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func handleFirstTime() {
      let userDefaults = UserDefaults.standard
      let firstTime = userDefaults.bool(forKey: "FirstTime")
      if firstTime {
        let checklist = Checklist(name: "List")
        lists.append(checklist)
        indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
      }
    }
    
    //Here you tell the lists array that the Checklists it contains should be sorted using some specific logic.
    func sortChecklists() {
        lists.sort { list1, list2 in
        return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    //This method gets the current “ChecklistItemID” value from UserDefaults, adds 1 to it, and writes it back to UserDefaults. It returns the previous value to the caller.
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
