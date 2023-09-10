//
//  ViewController.swift
//  Checklists
//
//  Created by James Fernandez on 8/24/23.
//
//------------------------------Chapter 9 & 10--------------------------------
import UIKit

//change object so it reads the table view controller
class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate { //promises to do things for AddItemTableViewControllerDelegate protocol
    
    //assigns existing ChecklistItem object being editted to the variable.
    var itemToEdit: ChecklistItem?
    //
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        
        //call method to load items.
        //loadChecklistItems()
        
        //changes title of the screen
        title = checklist.name
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      return paths[0]
    }
    func dataFilePath() -> URL {
      return
    documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // MARK: - Table View Data Source
    //this method tells how many rows are in table.
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return checklist.items.count
    }
    
    //This method will call the method and pass the array then it will return the info to the table.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table View Delegate
    //if user taps row it will select the item.
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ){
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    //this method gives the item the checkmark or not.
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    //sets the item text to label.
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //------------------------------Chapter 11, 12 & 13--------------------------------
    
    //This will enable swipe to delete.
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ){
        // deletes the Item from the array.
        checklist.items.remove(at: indexPath.row)
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
    
    // MARK: - Add Item ViewController Delegates
    func addItemViewControllerDidCancel(
        _ controller: ItemDetailViewController
    ){
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem
    ){
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
        //saveChecklistItems()
    }
    
    // MARK: - Navigation
    //checks to see which disclosure was tapped on whether we add or edit.
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        // 1
        if segue.identifier == "AddItem" {
            // 2
            let controller = segue.destination as! ItemDetailViewController
            // 3
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    //will update the item being edited to the corresponding index its from.
    func addItemViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
    ){
        //finds row of ChecklistItem
        if let index = checklist.items.firstIndex(of:item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        //saveChecklistItems()
    }
}
