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
    
    //create array list.
    var items = [ChecklistItem]()
    //assigns existing ChecklistItem object being editted to the variable.
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Enables large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //assign strings for the list to an array.
        let item1 = ChecklistItem()
          item1.text = "Walk the dog"
          items.append(item1)
          let item2 = ChecklistItem()
          item2.text = "Brush my teeth"
          item2.checked = true
          items.append(item2)
          let item3 = ChecklistItem()
          item3.text = "Learn iOS development"
          item3.checked = true
          items.append(item3)
          let item4 = ChecklistItem()
          item4.text = "Soccer practice"
          items.append(item4)
          let item5 = ChecklistItem()
          item5.text = "Eat ice cream"
          items.append(item5)
    }
    
    // MARK: - Table View Data Source
    //this method tells how many rows are in table.
    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
      return items.count
    }
    
    //This method will call the method and pass the array then it will return the info to the table.
    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "ChecklistItem",
        for: indexPath)
      let item = items[indexPath.row]
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
        let item = items[indexPath.row]
        item.checked.toggle()
        configureCheckmark(for: cell, with: item)
    }
      tableView.deselectRow(at: indexPath, animated: true)
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
      items.remove(at: indexPath.row)
    // 2
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(
      _ controller: AddItemViewController
    ){
      navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(
        _ controller: AddItemViewController,
        didFinishAdding item: ChecklistItem
      ){
      let newRowIndex = items.count
          items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
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
            let controller = segue.destination as! AddItemViewController
            // 3
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    //will update the item being edited to the corresponding index its from.
    func itemDetailViewController(
      _ controller: AddItemViewController,
      didFinishEditing item: ChecklistItem
    ){
        //finds row of ChecklistItem
    if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
    }
      navigationController?.popViewController(animated: true)
    }
}
