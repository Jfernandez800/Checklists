//
//  AllListsViewController.swift
//  Checklists
//
//  Created by James Fernandez on 9/1/23.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source
    //return number of arrays.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    //selection method so it greys the background of the object when tapped.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //store the index of the selected row into UserDefaults under the key “ChecklistIndex”.
        dataModel.indexOfSelectedChecklist = indexPath.row
        //send along the Checklist object from the row that the user tapped on.
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    //dequeue cell from table view and then setup the cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //hold the newly created cell and then see if you can dequeue a cell from the table view for the given identifier.
        let cell: UITableViewCell!
        //If there is no cell, create a new UITableViewCell instance with the cell style, and the identifier, that you want.
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
            //If there is a cell, then you assign its reference to the previously declared constant.
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        //updates cell info
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        let count = checklist.countUncheckedItems()
        //if the first part (the bit before the ?) evaluates to true, then the result of the expression would be the item after the ?. Otherwise, the result is the item after the :. It can be very handy in a lot of places to write simpler, more succinct code.
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    // MARK: - Navigation
    //set the properties of the new view controller before it becomes visible.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController){
        navigationController?.popViewController(animated: true)
    }
    
    //call tableView.reloadData() to refresh the entire table’s contents after you’ve sorted the data.
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist){
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist){
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //In this method, you create the view controller object for the Add/Edit Checklist screen and push it on to the navigation stack.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //whenever the navigation controller shows a new screen, call method.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool ){
        // Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    //UIKit automatically calls this method after the view controller becomes visible.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //view controller makes itself the delegate
        navigationController?.delegate = self
        //checks UserDefaults to see whether it has to perform the segue.
        let index = dataModel.indexOfSelectedChecklist
        //If the value of the “ChecklistIndex” setting is -1, then the user was on the app’s main screen before the app was terminated, and we don’t have to do anything. if the value of the “ChecklistIndex” setting is not -1, then the user was previously viewing a checklist and the app should segue to that screen.
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            //place the relevant Checklist object into the sender parameter of performSegue(withIdentifier:sender:).
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tableView.reloadData()
    }
}
