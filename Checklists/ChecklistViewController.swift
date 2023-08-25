//
//  ViewController.swift
//  Checklists
//
//  Created by James Fernandez on 8/24/23.
//

import UIKit

//change object so it reads the table view controller
class ChecklistViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Table View Data Source
    //this method tells how many rows are in table.
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 100 }// tells table that we have 100 rows.
    
    //this method grabs a copy of the prototype cell and returns it.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
      
        let label = cell.viewWithTag(1000) as! UILabel
            
            //Points to the row that the cell is intended for.
            if indexPath.row % 5 == 0 {
              label.text = "Walk the dog"
            } else if indexPath.row % 5 == 1 {
              label.text = "Brush my teeth"
            } else if indexPath.row % 5 == 2 {
              label.text = "Learn iOS development"
            } else if indexPath.row % 5 == 3 {
              label.text = "Soccer practice"
            } else if indexPath.row % 5 == 4 {
              label.text = "Eat ice cream"
            }
        // End of new code block
        return cell }
    
    // MARK: - Table View Delegate
    //if user taps row.
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ){
    if let cell = tableView.cellForRow(at: indexPath) {
        if cell.accessoryType == .none {
          cell.accessoryType = .checkmark
    } else {
          cell.accessoryType = .none
        }
    }
      tableView.deselectRow(at: indexPath, animated: true)
    }
}

