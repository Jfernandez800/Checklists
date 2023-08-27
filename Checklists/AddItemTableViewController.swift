//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by James Fernandez on 8/27/23.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
      navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
      navigationController?.popViewController(animated: true)
    }
}
