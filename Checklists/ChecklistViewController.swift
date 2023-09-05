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
    //
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        
        //call method to load items.
        loadChecklistItems()
        
        //changes title of the screen
        title = checklist.name
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
        saveChecklistItems()
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
        saveChecklistItems()
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
        saveChecklistItems()
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
        saveChecklistItems()
    }
    
    //------------------------------Chapter 15--------------------------------
    //returns the full path to the documents folder.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    //uses documentsDirectory method to construct the full path to the file to store the checklist items.
    func dataFilePath() -> URL {
        return
        documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        // creates instance of PropertyListEncoder.
        let encoder = PropertyListEncoder()
        do {
            // Will encode the the items in an array.
            let data = try encoder.encode(items)
            // If encoder fails it will jump to catch.
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
            // if it fails show error message.
        } catch { // 6
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        // assign results from called method to path.
        let path = dataFilePath()
        // will attempt to load the contents
        if let data = try? Data(contentsOf: path) {
            // if found, it will load the entire array.
            let decoder = PropertyListDecoder()
            do {
                // loads the saved data back into items and decodes them.
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
                // if it fails show error message.
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
