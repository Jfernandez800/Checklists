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
        return 1 }// tells table that we have one row.
    
    //this method grabs a copy of the prototype cell and returns it.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        return cell
    }
}

