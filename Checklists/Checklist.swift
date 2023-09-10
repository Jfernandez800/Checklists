//
//  Checklist.swift
//  Checklists
//
//  Created by James Fernandez on 9/4/23.
//

import UIKit

class Checklist: NSObject, Codable {

    var name = ""
    //creates a new empty array that can hold ChecklistItem objects and assigns it to items prop.
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    //This initializer takes one parameter, name, and places it into the property called name.
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        //taking a new iconName parameter and assigning it to the object’s iconName property.
        self.iconName = iconName
        super.init()
    }
    
    //This method asks the Checklist object how many of its ChecklistItem objects are still not checked. The method returns this count as an Int value.
    func countUncheckedItems() -> Int {
        return items.reduce(0) {
            //loop through the ChecklistItem objects from the items array. If an item object has its checked property set to false, you increment the local variable count by 1.
            cnt,item in cnt + (item.checked ? 0 : 1)
        }
    }
}
