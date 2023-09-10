//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by James Fernandez on 8/27/23.
//

import UIKit

//delegate protocol contract between Screen B
protocol ItemDetailViewControllerDelegate: AnyObject {
    //when cancel is pressed.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    //this will pass the parameter to ChecklistItem object.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    //did user finish editing
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate { //can now be a delegate for text fields.
    //connects the row from addItem to done.
    @IBOutlet weak var textField: UITextField!
    //sends messages from within view controller to enable or disable done bar button.
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    //
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            //If the user is adding a new item, the switch is initially off
            shouldRemindSwitch.isOn = item.shouldRemind
            //set the displayed date in the date picker.
            datePicker.date = item.dueDate
            }
    }
    
    //This method will automatically bring the keyboard out when addItem is active.
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    //sends message to delegate that cancel was tapped.
    @IBAction func cancel() {
      delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    //sends message to delegate that done was tapped and passes new Checklist object from text field.
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn  // add this
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn  // add this
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK: - Table View Delegates
    //disables selections on the row that is being created.
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {       //question mark gives it the ability to return nil. so it tells the row to do nothing when tapped.
    return nil
    }
     
    // MARK: - Text Field Delegates
    //This method changes the text every time user taps or cut/paste.
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
        //figures out what the new text is.
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        //once the text is done it checks to see if text field is empty to enable or disable done.
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    //When the Remind Me switch is toggled to ON, this prompts the user for permission to send local notifications.
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _
                in
            }
        }
    }
}
