//
//  AllListsViewController.swift
//  Checklists
//
//  Created by James Fernandez on 9/1/23.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    //array will hold Checklist objects
    var lists = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Enables large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //registers our cell identifier with the table view so that the table view knows which cell class should be used to create a new table view cell instance when a dequeue request comes in with that cell identifier.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:
                            cellIdentifier)
        
        // Add placeholder data
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        list = Checklist(name: "Groceries")
        lists.append(list)
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        list = Checklist(name: "To Do")
        lists.append(list)
    }
    
    // MARK: - Table view data source
    //return number of arrays.
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return lists.count
    }
    
    //selection method so it greys the background of the object when tapped.
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ){
        //send along the Checklist object from the row that the user tapped on.
        let checklist = lists[indexPath.row]
        performSegue(
            withIdentifier: "ShowChecklist",
            sender: checklist)
    }
    
    //dequeue cell from table view and then setup the cell.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath)
        //updates cell info
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // MARK: - Navigation
    //set the properties of the new view controller before it becomes visible.
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as!
            ListDetailViewController
            controller.delegate = self
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as!
        ListDetailViewController
            controller.delegate = self
          }
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController
    ){
        navigationController?.popViewController(animated: true)
    }
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist
    ){
        let newRowIndex = lists.count
        lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    lists.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}
