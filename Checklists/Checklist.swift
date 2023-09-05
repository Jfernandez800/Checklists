//
//  Checklist.swift
//  Checklists
//
//  Created by James Fernandez on 9/4/23.
//

import UIKit

class Checklist: NSObject {

    var name = ""
    
    //This initializer takes one parameter, name, and places it into the property called name.
    init(name: String) {
      self.name = name
      super.init()
    }
    
}
