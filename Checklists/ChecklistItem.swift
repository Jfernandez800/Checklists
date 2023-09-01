//
//  ChecklistItem.swift
//  Checklists
//
//  Created by James Fernandez on 8/26/23.
//

import Foundation

//satisfies the equatable requirement.
class ChecklistItem: NSObject, Codable { //ChecklistItem will conform to the Codable protocol.
  var text = ""
  var checked = false
}
